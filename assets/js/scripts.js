var app = angular.module("myApp", []);

app.directive('capitalize', function () {
	return {
		require: 'ngModel',
		link: function (scope, element, attrs, modelCtrl) {
			var capitalize = function (inputValue) {
				if (inputValue == undefined) inputValue = '';
				var capitalized = inputValue.charAt(0).toUpperCase() + inputValue.slice(1);
				if (capitalized !== inputValue) {
					modelCtrl.$setViewValue(capitalized);
					modelCtrl.$render();
				}
				return capitalized;
			}
			modelCtrl.$parsers.push(capitalize);
		}
	};
});

app.directive('cyrillic', function () {
	return {
		require: 'ngModel',
		link: function (scope, element, attrs, modelCtrl) {
			var cyrillic = function (value) {
				if (value == undefined) value = '';
				var filtered = value.replace(/[^а-яё\-]/gi, '').replace('--', '-');
				if (filtered !== value) {
					modelCtrl.$setViewValue(filtered);
					modelCtrl.$render();
				}
				return filtered;
			}
			modelCtrl.$parsers.push(cyrillic);

			element.on('keypress', function (e) {
				var symbol = String.fromCharCode(e.charCode);
				if (/[\s]/gi.test(symbol)) {
					e.preventDefault();
				}
			});

			element.on('blur', function (e) {
				if (/[\-]$/.test(this.value)) {
					this.value = this.value.slice(0, -1);
				}
			});
		}
	};
});

app.controller("loginController", function ($scope, $http) {
	$scope.required_message = 'Поле является обязательным для заполнения';

	$scope.login = function () {
		$scope.submited = true;
		if ($scope.form.$valid) {
			$http.post('/ServiceModel/AuthService.svc/Login', {
				'TimeZoneOffset': new Date().getTimezoneOffset(),
				'UserName': $scope.email,
				'UserPassword': $scope.pass,
				'WorkspaceName': 'Default'
			}).success(function (result) {
				if (!result) return;
				if (result.Code === 0) {
				    localStorage.setItem('PromoCode', $scope.pcode);
					location.replace('/0/Nui/ViewModule.aspx');
				} else {
					alert(result.Message);
				}
			});
		}
	}
});

app.controller("recoveryController", function ($scope, $http) {
	$scope.required_message = 'Поле является обязательным для заполнения';
	$scope.step = 1;

	$scope.checkPassword = function () {
		$scope.step3.confirmPassword.$setValidity('dontMatch', $scope.password === $scope.confirmPassword);
	};

	$scope.codeChange = function () {
		this.step2.code.$setValidity('wrongCode', true);
	}

	$scope.sendCode = function () {
		var type = this.type;
		if (type) {
			this.step1Submited = true;
		}
		if (!(type && this.step1[type].$valid)) {
			return;
		}

		$http.post("/Recovery.aspx/SendCodeForPasswordChange", { 'number': this[type], 'type': type })
			.success(function (result) {
				if (!result) return;
				result = JSON.parse(result.d).SendCodeForPasswordChangeResult;
				if (result.Code == 0) {
					$scope.codeId = result.CodeId;
					$scope.step = 2;
				} else {
					alert(result.Message);
				}
			});
	};

	$scope.verifyCode = function () {
		this.step2Submited = true;
		if (this.step2.$invalid) {
			return;
		}
		$http.post("/Recovery.aspx/VerifyCodeForPasswordChange", { 'codeId': this.codeId, 'code': this.code })
			.success(function (result) {
				if (!result) return;
				result = JSON.parse(result.d).VerifyCodeForPasswordChangeResult;
				if (result.Code == 0) {
					$scope.step = 3;
				} else {
					$scope.step2.code.$setValidity('wrongCode', result.MaxAttemptsReached || result.CodeExpired);
					result.Message = result.Message || result.CodeExpired ? 'Время жизни кода истекло' : '';
					result.Message = result.Message || result.MaxAttemptsReached ? 'Превышено максимальное к-ство попыток' : '';
					if (result.Message) {
						alert(result.Message);
					}
				}
			});
	};

	$scope.changePassword = function () {
		this.step3Submited = true;
		if (this.step3.$invalid) {
			return;
		}
		$http.post("/Recovery.aspx/ChangePassword", { 'code': this.code, 'codeId': this.codeId, 'password': this.password, 'type': this.type })
			.success(function (result) {
				if (!result) return;
				result = JSON.parse(result.d).ChangePasswordResult;
				if (result.Code == 0) {
					location.replace('Login.aspx');
				} else {
					alert(result.Message);
				}
			});
	};
});

app.controller("registerController", function ($scope, $http, $interval) {
	$scope.required_message = 'Поле является обязательным для заполнения';
	window.scope = $scope;
	$scope.phoneWidth = 100;
	$scope.emailWidth = 100;
	$scope.phoneInBlockList = false;
	$scope.emailInBlockList = false;
	$scope.phoneExists = false;
	$scope.emailExists = false;
	$scope.emailCodeCorrect = true;
	$scope.phoneCodeCorrect = true;
	$scope.phoneCodeTime = 60;
	$scope.emailCodeTime = 180;
	var now = new Date();
	var days = [1];
	var minYear = now.getFullYear() - window.maxAge - 1;
	var maxYear = now.getFullYear() - window.minAge;
	var years = [];
	var monthes = [
		{ value: 0, name: 'Январь' },
		{ value: 1, name: 'Февраль' },
		{ value: 2, name: 'Март' },
		{ value: 3, name: 'Апрель' },
		{ value: 4, name: 'Май' },
		{ value: 5, name: 'Июнь' },
		{ value: 6, name: 'Июль' },
		{ value: 7, name: 'Август' },
		{ value: 8, name: 'Сентябрь' },
		{ value: 9, name: 'Октябрь' },
		{ value: 10, name: 'Ноябрь' },
		{ value: 11, name: 'Декабрь' }
	];

	for (var i = 2; i <= 31; i++) {
		days.push(i);
	}
	for (i = maxYear; i >= minYear; i--) {
		years.push(i);
	}
	$scope.days = days;
	$scope.monthes = monthes;
	$scope.years = years;

	$scope.verifiedHide = function(type) {
		this[type + 'VerifiedShow'] = false;
		this.submited = false;
		$interval.cancel(this[type + 'Timer']);
	}

	$scope.getMinutes = function (type) {
		return Math.floor(this[type] / 60);
	}

	$scope.sendNewCode = function (type) {
		$http.post('/Register.aspx/SendNewCode', { number: $scope[type], 'type': type })
			.success(function (result) {
				if (!(result && result.d)) {
					return;
				}
				result = JSON.parse(result.d).SendNewCodeResult;
				if (result.Code === 0) {
					$scope[type + 'CodeSent'] = true;
					$scope[type + 'MaxAttemptsReached'] = false;
					$scope[type + 'CodeExpired'] = false;
					$scope[type + 'CodeId'] = result.CodeId;
					$scope[type + 'Time'] = 0;
					$scope[type + 'Timer'] = $interval(function () {
						$scope[type + 'Time'] += 1;
						if ($scope[type + 'Time'] == $scope[type + 'CodeTime']) {
							$interval.cancel($scope[type + 'Timer']);
							$scope[type + 'CodeSent'] = false;
						}
					}, 1000);
					return;
				}
				$scope[type + 'InBlockList'] = result.InBlockList;
			});
	}

	$scope.verified = function (e, type) {
		e.preventDefault();
		if (this[type] === undefined) {
			$scope[type + 'Verify'] = true;
			return;
		}
		if (!($scope[type + 'InBlockList'] || $scope[type + 'Exists'])) {
			$scope.sendVerificationCode(this[type], type)
		}
	}

	$scope.sendVerificationCode = function(number, type) {
		$scope.loaderShow = true;
		$http.post('/Register.aspx/SendVerificationCodes', {number: number, type: type})
			.success(function (result) {
				$scope.loaderShow = false;
				if (!(result && result.d)) {
					return;
				}
				result = JSON.parse(result.d).SendVerificationCodesResult;
				if (result.Code === 0) {
					//Запускаем таймер
					$scope[type + 'CodeId'] = result.CodeId;
					$scope[type + 'CodeSent'] = true;
					$scope[type + 'Time'] = 0;
					$scope[type + 'Timer'] = $interval(function () {
						$scope[type + 'Time'] += 1;
						if ($scope[type + 'Time'] == $scope[type + 'CodeTime']) {
							$interval.cancel($scope[type + 'Timer']);
							$scope[type + 'CodeSent'] = false;
						}
					}, 1000);
					$scope[type + 'VerifiedShow'] = true;
				} else {
					$scope[type + 'InBlockList'] = result.IsInBlockList;
					$scope[type + 'Exists'] = result.IsExists;
				}
			});
	}

    $scope.confirmCode = function(type) {
        $scope[type + 'ConfirmSubmited'] = true;
        if ($scope[type + 'Form'].$valid && !($scope[type + 'CodeExpired'] || $scope[type + 'MaxAttemptsReached'] ||
            $scope[type + 'InBlockList'] || $scope[type + 'Exists'])) {
            $http.post('/Register.aspx/Verify', { codeId: $scope[type + 'CodeId'], code: $scope[type + 'Code'] })
                .success(function(result) {
                    if (!(result && result.d)) {
                        return;
                    }
                    result = JSON.parse(result.d).VerifyResult;
                    $scope[type + 'Form'][type + 'Code'].$setValidity(type + 'CodeCorrect', result.IsCodeCorrect);
                    $scope[type + 'CodeExpired'] = result.IsCodeExpired;
                    $scope[type + 'MaxAttemptsReached'] = result.IsMaxAttemptsReached;
                    $scope[type + 'InBlockList'] = result.IsInBlockList;
                    if (result.IsCodeCorrect) {
                        $scope[type + 'NotConfirmed'] = false;
                        $scope.verifiedHide(type);
                        $scope[type + 'ConfrirmButton'] = false;
                        $scope[type + 'Width'] = 100;
                        // При смене номера и повторному подтверждению - чистим поле "код из смс" и скрываем валидацию
                        $scope[type + 'MaxAttemptsReached'] = false;
                        $scope[type + 'Code'] = '';
                    }
                });
        }
    };

    $scope.register = function() {
        this.submited = true;
        if (this.form.$valid && $scope.phoneNotConfirmed === false) {
            $scope.loaderShow = true;
            var token = {
                Fname: this.fname,
                Sname: this.sname,
                Mname: this.mname,
                PCode: this.pcode,
                Year: this.byear,
                Month: +this.bmonth + 1,
                Day: this.bday,
                Phone: this.phone,
                Email: this.email,
                TimeZoneOffset: getTimeZone()
            }
            $http.post('/Register.aspx/Register', { 'token': token })
                .success(function(result) {
                    if (!(result && result.d)) return;
                    result = JSON.parse(result.d).RegisterResult;
                    $http.get('https://www.google-analytics.com/collect?v=1&tid=UA-57742399-1' +
                        '&cid=' + result.UniqueClientId + '&uid=' + result.UniqueClientId +
                        '&t=event&ec=register&ea=click&el=step1');
                    $http.post('/ServiceModel/AuthService.svc/Login', {
                        'TimeZoneOffset': new Date().getTimezoneOffset(),
                        'UserName': result.Login,
                        'UserPassword': result.Password,
                        'WorkspaceName': 'Default'
                    }).success(function(response) {
                        if (response.Code === 0) {
                            localStorage.setItem('ApplicationId', result.ApplicationId);
                            localStorage.setItem('PromoCode', result.PromoCode);
                            document.location = '/0/Nui/ViewModule.aspx#MyLoansModule';
                        }
                    });
                });
        }
    };

	function daysInMonth(month, year) {
		return new Date(year, 1 * month + 1, 0).getDate();
	}

	function getTimeZone() {
		/*var offset = new Date().getTimezoneOffset();
		 var sign = offset < 0 ? true : false;
		 offset = Math.abs(offset);
		 var hour = Math.floor(offset/60);
		 hour = hour > 9 ? hour : '0' + hour;
		 var minute = offset%60;
		 minute = minute > 9 ? minute : '0' + minute;
		 var result = 'GMT' + (sign ? '+' : '-') + hour + ':' + minute;
		 return result*/
		return /\((.*)\)/.exec(new Date().toString())[1];
	}

	$scope.bmonthChange = function () {
		var days = [];
		var day = Math.min(now.getDate() + 1, daysInMonth(now.getMonth(), minYear));
		if ($scope.byear == minYear && $scope.bmonth == now.getMonth()) {
			for (var j = day; j <= 31; j++) {
				days.push(j);
			}
		} else if ($scope.byear == maxYear && $scope.bmonth == now.getMonth()) {
			day = Math.min(now.getDate(), daysInMonth(now.getMonth(), maxYear));
			for (var j = 1; j <= day; j++) {
				days.push(j);
			}
		} else {
			day = daysInMonth($scope.bmonth, $scope.byear);
			for (var j = 1; j <= day; j++) {
				days.push(j);
			}
		}
		$scope.days = days;
		if (days.indexOf(parseInt(this.bday)) == -1) {
			this.bday = days[0];
		}
	}

	$scope.byearChange = function () {
		if (this.byear == minYear) {
			this.monthes = monthes.slice(now.getMonth());
		} else if (this.byear == maxYear) {
			this.monthes = monthes.slice(0, now.getMonth() + 1);
		} else {
			this.monthes = monthes;
		}
		if (this.monthes.map(function(el) { return el.value }).indexOf(parseInt(this.bmonth)) == -1) {
			this.bmonth = this.monthes[0].value;
		}
		$scope.bmonthChange();
	}

	$scope.numberChange = function(type) {
		$scope[type + 'Exists'] = $scope[type + 'InBlockList'] = false;
		$scope[type + 'NotConfirmed'] = $scope[type + 'ConfrirmButton'] = $scope[type] === undefined ? false : true;
		$scope[type + 'Width'] =  $scope[type] === undefined ? 100 : 60;
	}

	$scope.codeChange = function(type) {
		$scope[type + 'Form'][type + 'Code'].$setValidity(type + 'CodeCorrect', true);
	}

	$scope.keyPress = function(e, type) {
		var symbol = String.fromCharCode(e.charCode);
		if (/[^а-яё]+/i.test(symbol)) {
			e.preventDefault();
			$scope[type + 'Cyrillic'] = true;
		} else {
			$scope[type + 'Cyrillic'] = false;
		}
	}

	$scope.byear = maxYear;
	$scope.bmonth = 0;
	$scope.bday = 1;//now.getDate();
	
	var init = function() {
		$scope.byearChange();
		$scope.bmonthChange();
	}
	
	init();
});

$(document).ready(function () {
	$.mask.definitions = { '_': '[0-9]' };
	$('#phone').mask('+7(9__) ___ - __ - __');
	$('#confirm-phone').mask('+7(9__) ___ - __ - __');
});
