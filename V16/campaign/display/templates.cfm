<cfset getComponent = createObject('component', 'WEX.emailservices.cfc.sendgrid')>
<cfset getSendgridInformations = getComponent.getSendgridInformations()>
<cfparam name="attributes.want_email" default="1">
<cfinclude template="../query/get_cons.cfm">
<cfinclude template="../query/get_pars.cfm">
<cfset mailList=valuelist(get_cons.CONSUMER_EMAIL)>
<cfset mailList=valuelist(get_pars.COMPANY_PARTNER_EMAIL)>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='43645.SendGrid'> - <cf_get_lang dictionary_id='36238.Templates'>
    </cfsavecontent>
    <cf_box title="#head#" popup_box="1">
        <cfif getSendgridInformations.recordcount and getSendgridInformations.IS_SENDGRID_INTEGRATED eq 1 and len(getSendgridInformations.MAIL_API_KEY)>    
            <cf_flat_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='58820.Title'></th>
                        <th><cf_get_lang dictionary_id='59088.Type'></th>
                        <th width="20"><a href="javascript://"><i class="fa fa-envelope-o"></i></a></th>
                    </tr>
                </thead>
                <tbody id="templates"></tbody>
            </cf_flat_list>
        <cfelse>
            <div class="ui-info-text">
                <span><cf_get_lang dictionary_id='62461.Entegrasyon için iletişime geçiniz.'></span>
                <ul>
                    <li><a href="tel:+90 850 441 23 23">+90 850 441 23 23</a></li>
                    <li><a href="mailto:workcube@workcube.com">workcube@workcube.com</a></li>
                </ul>
            </div>
        </cfif>
    </cf_box>
    <script>
        function sendMailTemplate(template_id = ""){
            if(confirm("<cf_get_lang dictionary_id='46716.Are you sure you want to send email?'>?"))	
            {   <cfif len(mailList)>
                    data = {
                        "template_id": template_id,
                        "emails": [<cfloop list="#mailList#" index="i" item="j"><cfoutput>"#j#"<cfif ListLen(mailList) neq i>,</cfif></cfoutput></cfloop>],
                        "from_address": "<cfoutput>#getSendgridInformations.sender_mail#</cfoutput>"
                    };
                    $.ajax({ 
                        url :'/wex.cfm/sendgrid/send_mail', 
                        method: 'post', 
                        contentType: 'application/json; charset=utf-8', 
                        dataType: "json", 
                        data : JSON.stringify(data), 
                        success : function(response){ alert("<cf_get_lang dictionary_id='49454.Email sent.'>!");} 
                    });
                <cfelse>
                    alert("<cf_get_lang dictionary_id='56664.No contacts to send email. Please check! Select the contacts you want to send email from the list.'>.");
                    return false;
                </cfif>
            }
        }
        $(function (){
           
            var data = {};
            data.key = "<cfoutput>#getSendgridInformations.mail_api_key#</cfoutput>"
            $.ajax({
                url :'/wex.cfm/sendgrid/templates',
                method: 'post',
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data : JSON.stringify(data),
                success : function(response){
                    if(response.templates.length == 0){
                        $('#templates').append("<tr><td colspan='4'><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>");
                    }
                    else{
                        for (var i = 0; i < response.templates.length; i++) {
                            func = 'sendMailTemplate("'+response.templates[i].id+'")';
                            var row = i+1;
                            $('#templates').append("<tr><td width='20'>"+row+"</td><td><a href='javascript://' onclick='"+func+"'>"+response.templates[i].name+"</a></td><td>"+response.templates[i].generation+"</td><td><a href='javascript://' onclick='"+func+"'><i class='fa fa-envelope-o'></i></a></td></tr>")
                        }
                    }
                    
                }
            });            
        });
    </script>
</div>
