<cftry>
    <cfset getParameter = parameter.getParameter() />
    <cfquery name = "PASSWORD_SETTINGS_COUNT" datasource = "#getParameter.dsn#">
        SELECT TOP 1 PASSWORD_ID FROM PASSWORD_CONTROL ORDER BY PASSWORD_ID DESC
    </cfquery>
    <cfif PASSWORD_SETTINGS_COUNT.recordCount eq 0>
        <cfquery datasource="#getParameter.dsn#" name="add_password_inf" result="result">
            INSERT INTO PASSWORD_CONTROL
            (
                PASSWORD_LENGTH,
                PASSWORD_LOWERCASE_LENGTH,
                PASSWORD_UPPERCASE_LENGTH,
                PASSWORD_NUMBER_LENGTH,
                PASSWORD_SPECIAL_LENGTH,
                PASSWORD_HISTORY_CONTROL,
                PASSWORD_CHANGE_INTERVAL,
                PASSWORD_NAME,
                PASSWORD_STATUS
            )
            VALUES
            (
                6,
                1,
                1,
                1,
                1,
                0,
                0,
                'Standart',
                1
            )
        </cfquery>
        <cfset queryid = result.IDENTITYCOL>
    <cfelse>
        <cfset queryid = PASSWORD_SETTINGS_COUNT.PASSWORD_ID>
    </cfif>
    <cfquery name = "PASSWORD_SETTINGS" datasource = "#getParameter.dsn#">
        SELECT 
            PASSWORD_LENGTH,
            PASSWORD_LOWERCASE_LENGTH,
            PASSWORD_UPPERCASE_LENGTH,
            PASSWORD_NUMBER_LENGTH,
            PASSWORD_SPECIAL_LENGTH
        FROM 
            PASSWORD_CONTROL
        WHERE PASSWORD_ID = #queryid#
    </cfquery>
    <div class="ui-info-text">
        <h1>Create User</h1>
    </div>
    <div class="col-md-12 paddingLess">
        <div class="panel panel-default">
            <div class="panel-heading">You must create a password according to the following criteria!</div>
            <div class="panel-body">
                <cfoutput>
                    <div class="col-md-12">Min characters : #PASSWORD_SETTINGS.PASSWORD_LENGTH#</div>
                    <div class="col-md-12">Min Lowercase characters : #PASSWORD_SETTINGS.PASSWORD_LOWERCASE_LENGTH#</div>
                    <div class="col-md-12">Min Uppercase characters : #PASSWORD_SETTINGS.PASSWORD_UPPERCASE_LENGTH#</div>
                    <div class="col-md-12">Min Number : #PASSWORD_SETTINGS.PASSWORD_NUMBER_LENGTH#</div>
                    <div class="col-md-12">Min Special characters : #PASSWORD_SETTINGS.PASSWORD_SPECIAL_LENGTH#</div>
                </cfoutput>
            </div>
        </div>
    </div>
    <cfform name="add_installation7" type="formControl" action="#installUrl#" method="post" onsubmit="passwordControl()">
        <input type="hidden" name="installation_type" id="installation_type" value="install_7" />
        <div class="ui-form-list">
		    <div class="col-md-12 paddingLess">
                <div class="form-group">
                    <label>Position Type <font color="red">*</font></label>
                    <div class="col-md-12 pdnl pdnr">
                        <input required class="form-control" message="Enter Position Type" maxlength="20" name="position_cat" id="position_cat" type="text" autocomplete="off" value="System Admin" readonly />
                    </div>
                </div>
                <div class="form-group">
                    <label>Email <font color="red">*</font></label>
                    <div class="col-md-12 pdnl pdnr">
                        <input required class="form-control" message="Enter Email" name="employee_email" id="employee_email" type="text" autocomplete="off" value="" />
                    </div>
                </div>
                <div class="form-group">
                    <label>Username <font color="red">*</font></label>
                    <div class="col-md-12 pdnl pdnr">
                        <input required class="form-control" message="Enter Title" maxlength="20" name="employee_username" id="employee_username" type="text" autocomplete="off" value="admin" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <label>Password <font color="red">*</font></label>
                    <div class="col-md-12 pdnl pdnr">
                        <input required class="form-control" message="Enter Password"  name="employee_password" id="employee_password" onkeyup="passwordControl()" type="password" autocomplete="off" />
                        <span id="password_message" style="color:#e42c2c;"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="ui-form-list-btn">
            <div class="col-md-12 paddingLess">
                <div class="form-group button-panel">
                    <input  class="btn btn-info" type="submit" id="submit_button" disabled value="Next Step">
                </div>
            </div>
        </div>
    </cfform>
    <script>
        function passwordControl(){

            function contains(deger,validChars)						
            {
                var sayac=0;				             
                for (i = 0; i < deger.length; i++)
                {
                    var char = deger.charAt(i);
                    if (validChars.indexOf(char) > -1)    
                        sayac++;
                }
                return(sayac);				
            }

            function alertMessage(message){
                $("#password_message").text(message);
                document.getElementById('employee_password').focus();
                document.getElementById("submit_button").disabled = true;
            }

            if ($('#employee_password').val() != "")
            {
                var number="0123456789";
                var lowercase = "abcdefghijklmnopqrstuvwxyz";
                var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                var ozel="!]'^%&([=?_<£)#$½{\|.:,;/*-+}>";
                
                var control_ifade_ = $('#employee_password').val();
                var containsNumberCase = contains(control_ifade_,number);
                var containsLowerCase = contains(control_ifade_,lowercase);
                var containsUpperCase = contains(control_ifade_,uppercase);
                var ozl = contains(control_ifade_,ozel);
                
                $("#password_message").text("");

                if(control_ifade_.length < <cfoutput>#PASSWORD_SETTINGS.PASSWORD_LENGTH#</cfoutput>)
                {
                    alertMessage("The minimum number of min characters required in password : <cfoutput>#PASSWORD_SETTINGS.PASSWORD_LENGTH#</cfoutput>");
                    return false;
                }
                
                if(<cfoutput>#PASSWORD_SETTINGS.PASSWORD_NUMBER_LENGTH#</cfoutput> > containsNumberCase)
                {
                    alertMessage("The minimum number required in the password : <cfoutput>#PASSWORD_SETTINGS.PASSWORD_NUMBER_LENGTH#</cfoutput>");
                    return false;
                }
                
                if(<cfoutput>#PASSWORD_SETTINGS.PASSWORD_LOWERCASE_LENGTH#</cfoutput> > containsLowerCase)
                {
                    alertMessage("The minimum number of uppercase letters required in the password :<cfoutput>#PASSWORD_SETTINGS.PASSWORD_LOWERCASE_LENGTH#</cfoutput>");
                    return false;
                }
                
                if(<cfoutput>#PASSWORD_SETTINGS.PASSWORD_UPPERCASE_LENGTH#</cfoutput> > containsUpperCase)
                {
                    alertMessage("The minimum number of lowercase letters required in the password : <cfoutput>#PASSWORD_SETTINGS.PASSWORD_UPPERCASE_LENGTH#</cfoutput>");
                    return false;
                }
                
                if(<cfoutput>#PASSWORD_SETTINGS.PASSWORD_SPECIAL_LENGTH#</cfoutput> > ozl)
                {
                    alertMessage("The minimum number of special characters required in the password : <cfoutput>#PASSWORD_SETTINGS.PASSWORD_SPECIAL_LENGTH#</cfoutput>");
                    return false;
                }
                document.getElementById("submit_button").disabled = false;
            }
            return true;
        }
    </script>

    <cfcatch type = "any">
        There was a problem, when your complex password settings creating!
    </cfcatch>
</cftry>