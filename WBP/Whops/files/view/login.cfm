<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <meta name="content-language" content="<cfoutput>#session.wp.language#</cfoutput>" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="mobile-web-app-capable" content="yes">
        <title>Whops</title>

        <link rel="stylesheet" type="text/css" href="../asset/css/login.css">
        <link rel="shortcut icon" type="image/x-icon" href="../asset/img/w.png">
        <script type="text/javascript" src="../asset/js/lib/jquery/jquery-min.js"></script>
        <script  type="text/javascript" src="../asset/js/lib/AjaxControl/dist/build.js"></script><!--- AjaxControl --->
        <script  type="text/javascript" src="../asset/js/script.js"></script>
    </head>
    <body class="login">
        <style>
            body{
                background: url(../asset/img/whops_bg.png) no-repeat center center;
                background-size: cover;
            }
            @media screen and (max-width: 1199px) {
                body {
                    background-color: #fafafa;
                    background-image: inherit;
                    width: inherit;
                    height: inherit;
                    overflow-y:scroll;
                }
            }
        </style>
        <div class="login_left"></div>
        <div class="login_right" style="margin-right:5%;">
            <div class="login_right_top">
                <div class="login_top_img">
                    <img src="../asset/img/whops_top.png" width="250"/>
                    <p class="login_top_img_write">powered by workcube</p>
                    <p class="login_top_img_write2">everything for shops</p>
                </div>
            </div>
            <div class="login_right_center_panel">
                <div class="login_content login_right_center">
                    <cfform id="form_login" name="form_login" action="/app/component/login.cfc?method=login" method="post">
                        <input type="hidden" name="screen_width" id="screen_width" value="-1" />
                        <input type="hidden" name="screen_height" id="screen_height" value="-1" />
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id='65211.Pos Kodu'></label>
                            <div class="col col-12">
                                <input name="pos_code" id="pos_code" type="text" required maxlength="50" autocomplete="off" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></label>
                            <div class="col col-12">
                                <input name="employee_username" id="employee_username" type="text" required maxlength="50" autocomplete="off" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-12"><cf_get_lang dictionary_id='57552.Şifre'></label>
                            <div class="col col-12">
                                <input name="employee_password" id="employee_password" type="password" required maxlength="50" autocomplete="off" />
                                <i class="fa fa-eye showPassword" id="login_password" onClick="showLoginPassword('password');"></i>
                            </div>
                        </div>
                        <div class="form-group">
                            <input type="hidden" name="language" id="language" value="<cfoutput>#session.wp.language#</cfoutput>">     
                            <button type="submit" id="login_button"><cf_get_lang dictionary_id='57554.Giriş'></button> 
                        </div>
                        <cfif isDefined("session.error_text")>
                            <div class="loginError">
                                <cfoutput>#session.error_text#</cfoutput>
                            </div>
                        </cfif>
                    </cfform>
                </div>
            </div>
            <div class="login_right_bottom">
                <ul>
                    <li class="linkedin">
                        <a href="https://www.linkedin.com/company/workcube">
                            <i class="fab fa-linkedin-in"></i>
                        </a>
                    </li>
                    <li class="instagram">
                        <a href="javascript://">
                            <i class="fab fa-instagram"></i>
                        </a>
                    </li>
                    <li class="facebook">
                        <a href="https://www.facebook.com/Workcube.ERP">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                    </li>
                    <li class="twitter">
                        <a href="https://twitter.com/workcube">
                            <i class="fab fa-twitter"></i>
                        </a>
                    </li>
                    <li class="youtube">
                        <a href="https://www.youtube.com/user/workcubecom">
                            <i class="fab fa-youtube"></i>
                        </a>
                    </li>
                </ul>
                <p> © 2021 <a href="http://www.workcube.com/" target="_blank" title="Workcube E-Business System">Workcube Community Cooperation</a></p>
            </div>	
        </div>
    </body>
    <script>
        function showLoginPassword(inputid){
            var input = document.getElementById(inputid);
            var eyeicon = document.querySelector("#" + inputid + " + i");
            var type = input.getAttribute("type");
            if(type == "password"){
                input.setAttribute("type","text");
                eyeicon.setAttribute("class","fa fa-lock");
            }else{
                input.setAttribute("type","password");
                eyeicon.setAttribute("class","fa fa-eye");
            }
        }

        AjaxFormSubmit("form_login",function(response){
            if(response.STATUS) location.href = '/<cfoutput>#request.self#</cfoutput>?wo=whops.welcome';
            else alert(response.MESSAGE);
        });
        try
        {
            document.getElementById('screen_width').value = document.body.clientWidth;
            document.getElementById('screen_height').value = document.body.clientHeight;
        }
        catch(e)
        {
            //
        }
    </script>
</html>