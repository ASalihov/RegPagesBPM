<%@ Page Title="" Language="C#" MasterPageFile="~/Eko.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="RegistrationPages.Signup" %>
<asp:Content ID="Content1" ContentPlaceHolderID="content" runat="server">
    <div data-ng-app="myApp" data-ng-controller="registerController">
    <div id="page">
        <div class="content">
            <h1 class="h1">Регистрация</h1>

            <div class="dialog-ovelray ng-hide" data-ng-show="loaderShow">
                <img class="loader" src="assets/img/load.png"/>
            </div>
            
            <form name="form" id="signup" class="form" novalidate>
                <div class="elem" ng-class="{err: snameCyrillic || (form.sname.$invalid && (form.sname.$dirty || submited))}">
                    <label class="label">Фамилия: <sup>*</sup></label>
                    <input class="textbox" type="text" name="sname" data-ng-model="sname" ng-keypress="keyPress($event, 'sname')" value="" capitalize required />
                    <p class="info" ng-show="form.sname.$error.required  && (form.sname.$dirty || submited)">{{required_message}}</p>
                    <p class="info" ng-show="snameCyrillic">Только буквы русского алфавита</p>
                </div>

                <div class="elem" ng-class="{err: fnameCyrillic || (form.fname.$invalid && (form.fname.$dirty || submited))}">
                    <label class="label">Имя: <sup>*</sup></label>
                    <input class="textbox" type="text" name="fname" value="" data-ng-model="fname" ng-keypress="keyPress($event, 'fname')" capitalize required/>
                    <p class="info" ng-show="form.fname.$error.required && (form.fname.$dirty || submited)">{{required_message}}</p>
                    <p class="info" ng-show="fnameCyrillic">Только буквы русского алфавита</p>
                </div>

                <div class="elem" ng-class="{err: no_nameCyrillic || (form.mname.$invalid && (form.mname.$dirty || submited))}">
                    <label class="label">Отчество: <sup>*</sup></label>
                    <input class="textbox" type="text" name="mname" value="" data-ng-model="mname" data-ng-disabled="no_mname" ng-keypress="keyPress($event, 'no_name')" capitalize  ng-required="!no_mname" />
                    <p class="info" ng-show="form.mname.$error.required && (form.mname.$dirty || submited)">{{required_message}}</p>
                    <p class="info" ng-show="no_nameCyrillic">Только буквы русского алфавита</p>
                </div>

                <div class="elem">
                    <label class="checkbox">
                        <input type="checkbox" name="no_mname" data-ng-model="no_mname" data-ng-change="mname=''">Нет отчества
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
                <label class="label">Мобильный телефон: <sup>*</sup></label>
                <div class="left" style="width:{{phoneWidth}}%">
                    <div class="elem" data-ng-class="{err: phoneExists || phoneInBlockList || phoneNotConfirmed || form.phone.$invalid && (form.phone.$dirty || submited || phoneVerify)}">                      
                        <input id="phone" class="textbox" type="text" name="phone" value="" data-ng-model="phone" data-ng-change="numberChange('phone')" required="required" />
                        <p class="info" data-ng-show="form.phone.$error.required && (form.phone.$dirty || submited || phoneVerify)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneExists">Данный номер телефона уже зарегистрирован, укажите другой номер</p>
                        <p class="info" data-ng-show="phoneInBlockList">Номер в черном списке</p>
                        <p class="info" data-ng-show="phoneExists ? false : phoneNotConfirmed">Номер не подтвержден</p>
                    </div>
                </div>
                <div class="right">
                    <div class="elem ng-hide" style="width:{{phoneButtonWidth}}%" data-ng-show="phoneConfrirmButton">
                        <a href="#" class="btn btn-blue" data-ng-click="verified($event, 'phone')">Подтвердить</a>
                    </div>
                </div>
                <div class="clear"></div>

                <label class="label">E-mail: <%--<sup>*</sup>--%></label>
                <div class="left" style="width:{{emailWidth}}%">
                    <div class="elem" data-ng-class="{err: emailExists || emailInBlockList || emailNotConfirmed || form.email.$invalid && (form.email.$dirty || submited || emailVerify)}">                    
                        <input class="textbox" type="email" name="email" value="" data-ng-model="email" data-ng-disabled="phoneNotConfirmed || (phone === undefined)" data-ng-change="numberChange('email')" <%--required--%> />
                        <p class="info" data-ng-show="form.email.$error.required && (form.email.$dirty || submited || emailVerify)"><%--{{required_message}}--%></p>
                        <p class="info" data-ng-show="form.email.$error.email && (form.email.$dirty || submited)">Неправильный адрес</p>
                        <p class="info" data-ng-show="emailExists">Email уже зарегистрирован</p>
                        <p class="info" data-ng-show="emailInBlockList">Email в черном списке</p>
                        <p class="info" data-ng-show="emailNotConfirmed">Email не подтвержден</p>
                    </div>
                </div>

                <div class="right">
                    <div class="elem ng-hide" data-ng-show="emailConfrirmButton">
                        <a href="#" class="btn btn-blue" data-ng-click="verified($event, 'email')">Подтвердить</a>
                    </div>
                </div>
                <div class="clear"></div>
                <div class="elem"> <!-- ng-class="{err: fnameCyrillic || (form.fname.$invalid && (form.fname.$dirty || submited))}"-->
                    <label class="label">Промокод: </label>
                    <input class="textbox" type="text" name="pcode" value="" data-ng-model="pcode"/> <%--ng-keypress="keyPress($event, 'pcode')"--%>
                </div>
                
                <div class="elem" data-ng-class="{err: form.agreeRules.$invalid && (form.agreeRules.$dirty || submited)}">
                    <label class="checkbox">
                        <input type="checkbox" name="agreeRules" data-ng-model="agreeRules" required />
                        Я, принимаю <a href="http://www.vkarmane-online.ru/files/flib/51.pdf" target="_blank">Общие условия договора потребительского займа</a>, <a href="http://www.vkarmane-online.ru/files/flib/69.pdf" target="_blank">Правила предоставления займов</a>, и <a href= "http://www.vkarmane-online.ru/files/flib/70.pdf" target="_blank">Информацию об условиях предоставления, использования и возврата потребительского микрозайма</a>. Предлагаю рассмотреть мое <a href="http://www.vkarmane-online.ru/files/flib/84.pdf" target="_blank">Заявление о предоставлении микрозайма</a>.
                    </label>
                    <p class="info" data-ng-show="form.agreeRules.$error.required && (form.agreeRules.$dirty || submited)">{{required_message}}</p>
                </div>
                
                <div class="elem" data-ng-class="{err: form.agreeASP.$invalid && (form.agreeASP.$dirty || submited)}">
                    <label class="checkbox">
                        <input type="checkbox" name="agreeASP" data-ng-model="agreeASP" required />
                        Я, подтверждаю принятие <a href="http://www.vkarmane-online.ru/files/flib/83.pdf" target="_blank">Соглашения об использовании АСП</a> и <a href="http://www.vkarmane-online.ru/files/flib/45.pdf" target="_blank">Правилами обработки персональных данных</a>.
                    </label>
                    <p class="info" data-ng-show="form.agreeASP.$error.required && (form.agreeASP.$dirty || submited)">{{required_message}}</p>
                </div>
          
                <div class="bottom">
                    <button type="submit" class="btn btn-red" data-ng-click="register()">Продолжить оформление</button>
                </div>
            </form>
        </div>

        <div class="dialog-ovelray ng-hide" data-ng-show="phoneVerifiedShow" data-ng-click="verifiedHide('phone')"></div>
        <div class="dialog ng-hide" data-ng-show="phoneVerifiedShow">
            <form id="confirmPhone" name="phoneForm" class="form" novalidate>
                <h1 class="h2">Подтверждение номера телефона</h1>
                <p class="text">
                    На указанный вами номер телефона отправлено СМС с кодом подтверждения.<br />
                    Введите полученный код что бы продолжить оформление заявки.
                </p>

                <div class="left">
                    <div class="elem" data-ng-class="{err: phoneCodeExpired || phoneMaxAttemptsReached || phoneForm.phoneCode.$invalid && (phoneForm.phoneCode.$dirty || phoneConfirmSubmited)}">
                        <label class="label">Код из СМС: <sup>*</sup></label>
                        <input class="textbox" type="text" name="phoneCode" data-ng-model="phoneCode" required data-ng-disabled="phoneCodeExpired || phoneMaxAttemptsReached" data-ng-change="codeChange('phone')" />
                        <p class="info" data-ng-show="phoneForm.phoneCode.$error.phoneCodeCorrect && (phoneForm.phoneCode.$dirty || phoneConfirmSubmited)">Неверный код подтверждения</p>
                        <p class="info" data-ng-show="phoneForm.phoneCode.$error.required && (phoneForm.phoneCode.$dirty || phoneConfirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneMaxAttemptsReached">Запросите новый код</p>
                        <p class="info" data-ng-show="phoneCodeExpired">Время жизни кода истекло</p>
                    </div>
                </div>

                <div class="right">
                    <div class="elem" data-ng-class="{err: phoneExists || phoneInBlockList || phoneForm.phone.$invalid && (phoneForm.phone.$dirty || phoneConfirmSubmited)}">
                        <label class="label">Мобильный телефон: <sup>*</sup></label>
                        <input id="confirm-phone" class="textbox" type="text" name="phone" data-ng-model="phone" data-ng-disabled="phoneCodeSent" required data-ng-change="numberChange('phone')" />
                        <p class="info" data-ng-show="phoneForm.phone.$error.required && (phoneForm.phone.$dirty || phoneConfirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="phoneExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="phoneInBlockList">Номер в черном списке</p>
                    </div>
                </div>

                <div class="clear"></div>

                <div class="elem" data-ng-show="!phoneCodeSent">
                    <button type="button" class="btn btn-blue" data-ng-click="sendNewCode('phone')">Получить код</button>
                </div>
                <div class="note" data-ng-show="phoneCodeSent">
                    <p class="timer">Код отправлен <span>{{phoneTime % 60}}</span> секунд назад</p>
                    <p><span>Если в течении 60 секунд смс не пришло, получите код повторно.</span></p>
                </div>
                
                <div class="bottom">
                    <button type="submit" class="btn btn-red" data-ng-click="confirmCode('phone')">Подтвердить</button>
                </div>
            </form>
        </div>

        <div class="dialog-ovelray ng-hide" data-ng-show="emailVerifiedShow" data-ng-click="verifiedHide('email')"></div>
        <div class="dialog ng-hide" data-ng-show="emailVerifiedShow">
            <form id="confirmEmail" name="emailForm" class="form" novalidate>
                <h1 class="h2">Подтверждение e-mail</h1>
                <p class="text">
                    На указанный вами e-mail отправлено письмо с кодом подтверждения.<br />
                    Введите полученный, код что бы продолжить оформление заякви.
                </p>

                <div class="left">
                    <div class="elem" data-ng-class="{err: emailCodeExpired || emailMaxAttemptsReached || emailForm.emailCode.$invalid && (emailForm.emailCode.$dirty || emailConfirmSubmited)}">
                        <label class="label">Код из Email: <sup>*</sup></label>
                        <input class="textbox" type="text" name="emailCode" data-ng-model="emailCode" required data-ng-disabled="emailCodeExpired || emailMaxAttemptsReached" data-ng-change="codeChange('email')" />
                        <p class="info" data-ng-show="emailForm.emailCode.$error.emailCodeCorrect && (emailForm.emailCode.$dirty || emailConfirmSubmited)">Неверный код подтверждения</p>
                        <p class="info" data-ng-show="emailForm.emailCode.$error.required && (emailForm.emailCode.$dirty || emailConfirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="emailMaxAttemptsReached">Запросите новый код</p>
                        <p class="info" data-ng-show="emailCodeExpired">Время жизни кода истекло</p>
                    </div>
                </div>

                <div class="right">
                    <div class="elem" data-ng-class="{err: emailExists || emailInBlockList || emailForm.email.$invalid && (emailForm.email.$dirty || emailConfirmSubmited)}">
                        <label class="label">E-mail: <sup>*</sup></label>
                        <input class="textbox" type="email" name="email" data-ng-model="email" data-ng-disabled="emailCodeSent" required data-ng-change="numberChange('email')" />
                        <p class="info" data-ng-show="emailForm.email.$error.required && (emailForm.email.$dirty || emailConfirmSubmited)">{{required_message}}</p>
                        <p class="info" data-ng-show="emailForm.email.$error.email && (emailForm.email.$dirty || emailConfirmSubmited)">Неправильный адрес</p>
                        <p class="info" data-ng-show="emailExists">Номер уже зарегистрирован</p>
                        <p class="info" data-ng-show="emailInBlockList">Адрес в черном списке</p>
                    </div>
                </div>

                <div class="clear"></div>

                <div class="elem" data-ng-show="!emailCodeSent">
                    <button type="button" class="btn btn-blue" data-ng-click="sendNewCode('email')">Получить код</button>
                </div>

                <div class="note" data-ng-show="emailCodeSent">
                    <p class="timer">Код отправлен <span>{{getMinutes('emailTime')}}</span> минуту <span>{{emailTime % 60}}</span> секунд назад</p>
                    <p><span>Если в течении 3 минут письмо не пришло, проверьте e-mail и получите код повторно.</span></p>
                </div>

                <div class="bottom">
                    <button type="submit" class="btn btn-red" data-ng-click="confirmCode('email')">Подтвердить</button>
                </div>
            </form>      
        </div>
    </div>
 </div>
</asp:Content>
