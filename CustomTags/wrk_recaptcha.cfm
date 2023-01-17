<!----attributes.submit_id  aktif edilecek butonun id'sidir---->
<!--- kullanımı : <cf_wrk_recaptcha submit_id="button_id"> ---->
<!----recaptcha params dosyasında 'var systemParam.recaptcha = true;' şeklinde tanımlanır true ise wrk recaptcha gelir, false veya hiç eklenmemişse recaptcha gelmez-----> 
<!----Developer : Esma R. Uysal---->
<script src="../JS/assets/lib/jquery/jquery-min.js"></script>
<cfparam name="attributes.submit_id" default="">
<cfparam name="attributes.recaptcha" default="false">
<cfif isDefined("application.systemParam") and StructKeyExists(application.systemParam.systemParam(),'recaptcha')>
    <cfset attributes.recaptcha = application.systemParam.systemParam().recaptcha>
</cfif>

<cfif not isdefined("getLang")>
	<cfif isdefined("caller.getLang")>
		<cfset getLang = caller.getLang>
	<cfelseif isdefined("caller.caller.getLang")>
		<cfset getLang = caller.caller.getLang>
	</cfif>
</cfif>
<cfif len(attributes.recaptcha) and attributes.recaptcha eq true>
    <input type="hidden" name="submit_id" id="submit_id" value="<cfoutput>#attributes.submit_id#</cfoutput>">
    <div id="wrk_recaptcha">
        <div class="input-group icon mt-2">
            <cfset returnString  = IMG_OUT()>
            <input class="form-control" type="text" id="recaptcha_kontrol" maxlength="5" onkeyup="recaptchaControl()">
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function(){
            $('#<cfoutput>#attributes.submit_id#</cfoutput>').prop('disabled',true);
            $("#refresh_button").click(function(){
                $("#wrk_recaptcha").load("../CustomTags/wrk_recaptcha.cfm",{submit_id : "<cfoutput>#attributes.submit_id#</cfoutput>"});
              });
        });
        function recaptchaControl() {
            var temp = document.getElementById("recaptcha_kontrol").value;
            var rtnStr = "<cfoutput>#returnString#</cfoutput>";      
            if(temp == rtnStr){
                $('#<cfoutput>#attributes.submit_id#</cfoutput>').removeAttr('disabled');
            }else{
                $('#<cfoutput>#attributes.submit_id#</cfoutput>').prop('disabled',true);
                if(temp.length == 5)
                {
                    alert("<cfoutput>#isDefined("getLang") ? getLang('myhome',673) : 'Recaptcha Hatalı'#</cfoutput>");
                }
            }
        }
    </script>
    <cffunction name="IMG_OUT" access="private" returntype="any">
        <cfscript>
            ntCaptchaLength = 5;
            stChars = "0,1,2,3,4,5,6,7,8,9," &
                        "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z," &
                        "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z";
            getRandIndex = 1;
            returnString = "";
            loopCntr =1;
            for(  loopCntr = 1; loopCntr <= ntCaptchaLength; loopCntr ++ ) {
                getRandIndex = randRange(1, listLen(stChars));
                returnString &= listGetAt(stChars, getRandIndex);
            }     
            IMG_SCREEN(returnString : returnString);
        </cfscript>
        <cfreturn returnString>
    </cffunction>
    <cffunction name="IMG_SCREEN" access="private" returntype="any">
        <cfargument name="returnString">
        <div class="col col-12"> 
            <div class="input-group col col-12" id="img_recaptcha" style="display:flex">
                <cfset funcimg3 = ImageCreateCaptcha(40,300,"#arguments.returnString#","high","Times New Roman, Times, serif", "25")>
                <cfimage action="writetoBrowser" source="#funcimg3#">
                <div style="background: white; align-self: center; text-align: center;">              
                    <a href="#"  id="refresh_button" style="text-decoration: none"><i class="catalyst-refresh" style="font-size:25px; color:gray;"></i></a>
                </div>
            </div>
        </div>
    </cffunction>
</cfif>

