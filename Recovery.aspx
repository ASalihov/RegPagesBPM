<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Recovery.aspx.cs" Inherits="RegistrationPages.Recovery" MasterPageFile="Eko.Master" %>

<asp:Content runat="server" ContentPlaceHolderID="content">
    <div id="page" data-ng-app="myApp" data-ng-controller="recoveryController">
        <div class="content">
            <h1 class="h1">Восстановление пароля</h1>

            <div id="recovery" class="form">
                <div class="elem">
                    <label class="radio">
                        <input type="radio" name="type" value="email" data-ng-model="type" checked>По e-mail
                    </label>
                    <label class="radio">
                        <input type="radio" name="type" value="phone" data-ng-model="type">По номеру мобильного телефона
                    </label>
                </div>

                <form name="step1" novalidate data-ng-show="step == 1">
                    <div class="elem" data-ng-show="type == 'email'" data-ng-class="{err: step1.email.$invalid && (step1.email.$dirty || step1Submited)}">
                        <label class="label">Введте e-mail, указанный Вами при регистации в личном кабинете: <sup>*</sup></label>
                        <input class="textbox" type="email" name="email" data-ng-model="email" data-ng-required="type == 'email'"/>
                        <p class="info" data-ng-show="step1.email.$error.required  && (step1.email.$dirty || step1Submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="step1.email.$error.email && (step1.email.$dirty || step1Submited)">Неправильный адрес</p>
                    </div>

                    <div class="elem" data-ng-show="type == 'phone'" data-ng-class="{err: step1.phone.$invalid && (step1.email.$dirty || step1Submited)}">
                        <label class="label">Введте телефон, указанный Вами при регистации в личном кабинете: <sup>*</sup></label>
                        <input id="phone" class="textbox" type="text" name="phone" data-ng-model="phone" data-ng-required="type == 'phone'"/>
                        <p class="info" data-ng-show="step1.phone.$error.required  && (step1.phone.$dirty || step1Submited)">{{required_message}}</p>
                    </div>

                    <div class="bottom">
                        <button type="submit" class="btn btn-red" data-ng-click="sendCode()">Отправить</button>
                        <a class="btn btn-blue" href="Login.aspx">Отмена</a>
                    </div>
                </form>

                <form name="step2" novalidate data-ng-show="step == 2">
                    <div class="elem left" data-ng-class="{err: step2.code.$invalid && (step2.code.$dirty || step2Submited)}">
                        <label class="label">Код подтверждения: <sup>*</sup></label>
                        <input class="textbox" type="text" name="code" data-ng-model="code" required data-ng-change="codeChange()" />
                        <p class="info" data-ng-show="step2.code.$error.required && (step2.code.$dirty || step2Submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="step2.code.$error.wrongCode && (step2.code.$dirty || step2Submited)">Неправильный код</p>
                    </div>

                    <div class="bottom">
                        <button type="submit" class="btn btn-red" data-ng-click="verifyCode()">Подтвердить</button>
                        <a class="btn btn-blue" href="Login.aspx">Отмена</a>
                    </div>
                </form>

                <form name="step3" novalidate data-ng-show="step == 3">
                    <div class="elem left" data-ng-class="{err: step3.password.$invalid && (step3.password.$dirty || step3Submited)}">
                        <label class="label">Пароль: <sup>*</sup></label>
                        <input class="textbox" type="password" name="password" data-ng-model="password" data-ng-pattern="/[0-9,a-z]{6,20}/i" required />
                        <p class="info" data-ng-show="step3.password.$error.required && (step3.password.$dirty || step3Submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="step3.password.$error.pattern && (step3.password.$dirty || step3Submited)">Пароль должен состоять из 6-20 букв или цифр</p>
                    </div>

                    <div class="elem left" data-ng-class="{err: step3.confirmPassword.$invalid && (step3.confirmPassword.$dirty || step3Submited)}">
                        <label class="label">Подтвердите пароль: <sup>*</sup></label>
                        <input class="textbox" type="password" name="confirmPassword" data-ng-model="confirmPassword" data-ng-change="checkPassword()" required/>
                        <p class="info" data-ng-show="step3.confirmPassword.$error.required  && (step3.confirmPassword.$dirty || step3Submited)">{{required_message}}</p>
                        <p class="info" data-ng-show="step3.confirmPassword.$error.dontMatch  && (step3.confirmPassword.$dirty || step3Submited)">Пароль не совпадает</p>
                    </div>

                    <div class="bottom">
                        <button type="submit" class="btn btn-red" data-ng-click="changePassword()">Сохранить</button>
                        <a class="btn btn-blue" href="Login.aspx">Отмена</a>
                    </div>
                </form>



            </div>
        </div>
    </div>
</asp:Content>
