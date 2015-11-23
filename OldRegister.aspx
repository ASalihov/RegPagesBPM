<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OldRegister.aspx.cs" Inherits="RegistrationPages.Register" MasterPageFile="Eko.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="content" runat="Server">
    <div data-ng-app="myApp" data-ng-controller="registerController">
        <div id="page">
            <div class="content">
                <h1 class="h1">Регистрация</h1>
                <form name="form" id="signup" class="form" novalidate>
                    <div class="elem" ng-class="{err: form.sname.$invalid && (form.sname.$dirty || submited)}">
                        <label class="label">Фамилия: <sup>*</sup></label>
                        <input class="textbox" type="text" name="sname" data-ng-model="sname" value="" capitalize cyrillic required />
                        <p class="info" ng-show="form.sname.$error.required  && (form.sname.$dirty || submited)">{{required_message}}</p>
                    </div>

                    <div class="elem" ng-class="{err: form.fname.$invalid && (form.fname.$dirty || submited)}">
                        <label class="label">Имя: <sup>*</sup></label>
                        <input class="textbox" type="text" name="fname" value="" data-ng-model="fname" capitalize cyrillic required />
                        <p class="info" ng-show="form.fname.$error.required && (form.fname.$dirty || submited)">{{required_message}}</p>
                    </div>

                    <div class="elem" ng-class="{err: form.mname.$invalid && (form.mname.$dirty || submited)}">
                        <label class="label">Отчество: <sup data-ng-hide="no_mname">*</sup></label>
                        <input class="textbox" type="text" name="mname" value="" data-ng-model="mname" data-ng-disabled="no_mname" capitalize cyrillic ng-required="!no_mname" />
                        <p class="info" ng-show="form.mname.$error.required && (form.mname.$dirty || submited)">{{required_message}}</p>
                    </div>

                    <div class="elem">
                        <label class="checkbox">
                            <input id="no_mname" type="checkbox" name="no_mname" data-ng-model="no_mname" data-ng-change="mname=''">Нет отчества
                        </label>
                    </div>

                    <div class="elem">
                        <label class="label">Дата рождения: <sup>*</sup></label>
                        <div class="date-group">
                            <select class="select" name="bday" data-ng-model="bday" required>
                                <option data-ng-repeat="day in days" value="{{day}}">{{day}}</option>
                            </select>
                            <select class="select" name="bmonth" data-ng-model="bmonth" data-ng-change="bmonthChange()" required>
                                <option data-ng-repeat="month in monthes" value="{{month.value}}">{{month.name}}</option>
                            </select>
                            <select class="select" name="byear" data-ng-model="byear" data-ng-change="byearChange()" required>
                                <option data-ng-repeat="year in years" value="{{year}}">{{year}}</option>
                            </select>
                        </div>
                    </div>

                    <div class="elem" data-ng-class="{err: phoneExists || phoneInBlockList || form.phone.$invalid && (form.phone.$dirty || submited)}">
                        <label class="label">Мобильный телефон: <sup>*</sup></label>
                        <input id="phone" class="textbox" type="text" name="phone" value="" data-ng-model="phone" data-ng-change="numberChange('phone')" required />
                        <p class="info" data-ng-show="form.phone.$error.required && (form.phone.$dirty || submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="phoneInBlockList">Номер в черном списке</p>
                    </div>

                    <div class="elem" data-ng-class="{err: emailExists || emailInBlockList || form.email.$invalid && (form.email.$dirty || submited)}">
                        <label class="label">E-mail: <sup>*</sup></label>
                        <input class="textbox" type="email" name="email" value="" data-ng-model="email" data-ng-change="numberChange('email')" required />
                        <p class="info" data-ng-show="form.email.$error.required && (form.email.$dirty || submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="form.email.$error.email && (form.email.$dirty || submited)">Неправильный адрес</p>
                        <p class="info" data-ng-show="emailExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="emailInBlockList">Номер в черном списке</p>
                    </div>

                    <div class="bottom">
                        <button type="button" class="btn btn-red" data-ng-click="continue()">Продолжить оформление</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="dialog-ovelray ng-hide" data-ng-show="showConfirm" data-ng-click="hideConfirmWindow()"></div>
        <div class="dialog ng-hide" data-ng-show="showConfirm">
            <form id="confirm" name="confirmForm" class="form" novalidate>
                <h1 class="h2">Подтверждение номера телефона</h1>
                <p class="text">
                    На указанный вами номер телефона отправлено СМС с кодом подтверждения.<br />
                    Введите полученный, код что бы продолжить оформление заякви.
                </p>

                <div class="left">
                    <div class="elem" data-ng-class="{err: phoneCodeExpired || phoneMaxAttemptsReached || confirmForm.phoneCode.$invalid && (confirmForm.phoneCode.$dirty || confirmSubmited)}">
                        <label class="label">Код из СМС: <sup>*</sup></label>
                        <input class="textbox" type="text" name="phoneCode" data-ng-model="phoneCode" required data-ng-disabled="phoneCodeExpired || phoneMaxAttemptsReached" data-ng-change="codeChange('phone')" />
                        <p class="info" data-ng-show="confirmForm.phoneCode.$error.phoneCodeCorrect && (confirmForm.phoneCode.$dirty || confirmSubmited)">Неверный код подтверждения</p>
                        <p class="info" data-ng-show="confirmForm.phoneCode.$error.required && (confirmForm.phoneCode.$dirty || confirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneMaxAttemptsReached">Запросите новый код</p>
                        <p class="info" data-ng-show="phoneCodeExpired">Время жизни кода истекло</p>
                    </div>
                </div>

                <div class="right">
                    <div class="elem" data-ng-class="{err: phoneExists || phoneInBlockList || confirmForm.phone.$invalid && (confirmForm.phone.$dirty || confirmSubmited)}">
                        <label class="label">Мобильный телефон: <sup>*</sup></label>
                        <input id="confirm-phone" class="textbox" type="text" name="phone" data-ng-model="phone" data-ng-disabled="phoneCodeSent" required data-ng-change="numberChange('phone')" />
                        <p class="info" data-ng-show="confirmForm.phone.$error.required && (confirmForm.phone.$dirty || confirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="phoneInBlockList">Номер в черном списке</p>
                    </div>

                    <div class="elem" data-ng-show="!phoneCodeSent">
                        <button type="button" class="btn btn-red" data-ng-click="sendNewCode('phone')">Получить код</button>
                    </div>
                    <div class="note" data-ng-show="phoneCodeSent">
                        <p class="timer">Код отправлен <span>{{getMinutes('phoneTime')}}</span> минуту <span>{{phoneTime % 60}}</span> секунд назад</p>
                        <p><span>Если в течении 3 минут письмо не пришло, проверьте e-mail и получите код повторно.</span></p>
                    </div>
                </div>

                <div class="clear"></div>

                <h1 class="h2">Подтверждение e-mail</h1>
                <p class="text">
                    На указанный вами e-mail отправлено письмо с кодом подтверждения.<br />
                    Введите полученный, код что бы продолжить оформление заякви.
                </p>

                <div class="left">
                    <div class="elem" data-ng-class="{err: emailCodeExpired || emailMaxAttemptsReached || confirmForm.emailCode.$invalid && (confirmForm.emailCode.$dirty || confirmSubmited)}">
                        <label class="label">Код из Email: <sup>*</sup></label>
                        <input class="textbox" type="text" name="emailCode" data-ng-model="emailCode" required data-ng-disabled="emailCodeExpired || emailMaxAttemptsReached" data-ng-change="codeChange('email')" />
                        <p class="info" data-ng-show="confirmForm.emailCode.$error.emailCodeCorrect && (confirmForm.emailCode.$dirty || confirmSubmited)">Неверный код подтверждения</p>
                        <p class="info" data-ng-show="confirmForm.emailCode.$error.required && (confirmForm.emailCode.$dirty || confirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="emailMaxAttemptsReached">Запросите новый код</p>
                        <p class="info" data-ng-show="emailCodeExpired">Время жизни кода истекло</p>
                    </div>
                </div>

                <div class="right">
                    <div class="elem" data-ng-class="{err: emailExists || emailInBlockList || confirmForm.email.$invalid && (confirmForm.email.$dirty || confirmSubmited)}">
                        <label class="label">E-mail: <sup>*</sup></label>
                        <input class="textbox" type="email" name="email" data-ng-model="email" data-ng-disabled="emailCodeSent" required data-ng-change="numberChange('email')" />
                        <p class="info" data-ng-show="confirmForm.email.$error.required && (confirmForm.email.$dirty || confirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="confirmForm.email.$error.email && (confirmForm.email.$dirty || confirmSubmited)">Неправильный адрес</p>
                        <p class="info" data-ng-show="emailExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="emailInBlockList">Адрес в черном списке</p>
                    </div>

                    <div class="elem" data-ng-show="!emailCodeSent">
                        <button type="button" class="btn btn-red" data-ng-click="sendNewCode('email')">Получить код</button>
                    </div>
                    <div class="note" data-ng-show="emailCodeSent">
                        <p class="timer">Код отправлен <span>{{getMinutes('emailTime')}}</span> минуту <span>{{emailTime % 60}}</span> секунд назад</p>
                        <p><span>Если в течении 3 минут письмо не пришло, проверьте e-mail и получите код повторно.</span></p>
                    </div>
                </div>

                <div class="clear"></div>

                <div class="elem" data-ng-class="{err: confirmForm.agreeRules.$invalid && (confirmForm.agreeRules.$dirty || confirmSubmited)}">
                    <label class="checkbox">
                        <input type="checkbox" name="agreeRules" data-ng-model="agreeRules" required>
                        Я принимаю условия <a href="#">соглашения</a>.
                    </label>
                    <p class="info" data-ng-show="confirmForm.agreeRules.$error.required && (confirmForm.agreeRules.$dirty || confirmSubmited)">{{required_message}}</p>
                </div>

                <div class="bottom">
                    <button type="submit" class="btn btn-red" data-ng-click="register()">Далее</button>
                </div>
            </form>
        </div>
    </div>

</asp:Content>





