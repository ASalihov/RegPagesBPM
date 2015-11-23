<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="RegistrationPages.Login"  MasterPageFile="Eko.Master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="content" Runat="Server">
    <div id="page" data-ng-app="myApp" data-ng-controller="loginController">
            <div class="content">
                <h1 class="h1">Вход</h1>

                <form id="login" name="form" class="form" novalidate>
                    <div class="elem" data-ng-class="{err: form.email.$invalid && (form.email.$dirty || submited)}">
                        <label class="label">Логин: <sup>*</sup></label>
                        <input class="textbox" type="text" name="email" data-ng-model="email" required/>
                        <p class="info" data-ng-show="form.email.$error.required  && (form.email.$dirty || submited)">{{required_message}}</p>
                    </div>

                    <div class="elem" data-ng-class="{err: form.pass.$invalid && (form.pass.$dirty || submited)}">
                        <label class="label">Пароль: <sup>*</sup></label>
                        <input class="textbox" type="password" name="pass" data-ng-model="pass" required/>
                        <p class="info" data-ng-show="form.pass.$error.required  && (form.pass.$dirty || submited)">{{required_message}}</p>
                    </div>
                    
                    <div class="elem"> <!-- ng-class="{err: fnameCyrillic || (form.fname.$invalid && (form.fname.$dirty || submited))}"-->
                        <label class="label">Промокод: </label>
                        <input class="textbox" type="text" name="pcode" value="" data-ng-model="pcode"/> <%--ng-keypress="keyPress($event, 'pcode')"--%>
                    </div>

                    <div class="bottom">
                        <button type="submit" class="btn btn-red" data-ng-click="login()">Войти</button>
                        <div class="reset">
                            <a href="Recovery.aspx">Забыли пароль?</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
</asp:Content>