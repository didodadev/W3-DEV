<cfsavecontent variable="ocak"><cf_get_lang_main no='180.Ocak'></cfsavecontent> 
<cfsavecontent variable="subat"><cf_get_lang_main no='181.şubat'></cfsavecontent> 
<cfsavecontent variable="mart"><cf_get_lang_main no='182.mart'></cfsavecontent> 
<cfsavecontent variable="nisan"><cf_get_lang_main no='183.nisan'></cfsavecontent> 
<cfsavecontent variable="mayis"><cf_get_lang_main no='184.mayıs'></cfsavecontent> 
<cfsavecontent variable="haziran"><cf_get_lang_main no='185.haziran'></cfsavecontent> 
<cfsavecontent variable="temmuz"><cf_get_lang_main no='186.temmuz'></cfsavecontent> 
<cfsavecontent variable="agustos"><cf_get_lang_main no='187.ağustos'></cfsavecontent> 
<cfsavecontent variable="eylul"><cf_get_lang_main no='188.eylül'></cfsavecontent> 
<cfsavecontent variable="ekim"><cf_get_lang_main no='189.ekim'></cfsavecontent> 
<cfsavecontent variable="kasim"><cf_get_lang_main no='190.kasım'></cfsavecontent> 
<cfsavecontent variable="aralik"><cf_get_lang_main no='191.aralık'></cfsavecontent> 

<cfset my_month_list="#ocak#,#subat#,#mart#,#nisan#,#mayis#,#haziran#,#temmuz#,#agustos#,#eylul#,#ekim#,#kasim#,#aralik#">

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.date1" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.online)>
	<cfset url_str = "#url_str#&online=#attributes.online#">
</cfif>
<cfif len(attributes.date1)>
	<cfset url_str = "#url_str#&date1=#attributes.date1#">					  
</cfif>
<cfif not isDefined("attributes.ic_dis")>
 <cfset attributes.ic_dis = 1>
</cfif>
<cfif isDefined("attributes.ic_dis")>
   <cfset url_str = "#url_str#&ic_dis=#attributes.ic_dis#">
</cfif>
<cfinclude template="../query/get_class_ex_class.cfm">
<cfinclude template="../query/get_training_sec_names.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_class_ex_class.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top"> 
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
        <tr> 
          <td class="headbold"><cf_get_lang_main no='2115.Eğitimler'></td>
           <!-- sil -->
		  <td valign="bottom" style="text-align:right;"> 
            <table>
              <cfform name="form1" method="post" action="">
                <tr> 
                  <td><cf_get_lang_main no='48.Filtre'>:</td>
                  <td><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;"></td>
				  <td>
					  <cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
					  <cfinput name="date1" type="text" value="#attributes.date1#" style="width:65px;" validate="#validate_style#" message="Tarih Girmelisiniz !">
					  <cf_wrk_date_image date_field="date1">
					  <cf_get_lang no='212.tarihinden itibaren'>
				  </td>
				  
                  <td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
                  <td><cf_wrk_search_button></td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border"> 
          <td> 
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <tr class="color-header" height="22"> 
                <td width="20"></td>
				<td class="form-title"><cf_get_lang_main no='7.Eğitim'></td>
				<td class="form-title" width="100"><cf_get_lang no='187.Eğitim Yeri'></td>
                <td class="form-title" width="150"><cf_get_lang no='23.Eğitimci'></td>
                <td class="form-title" width="100"><cf_get_lang_main no='330.Tarih'></td>
              </tr>
              <cfif get_class_ex_class.recordcount>
              <cfoutput query="get_class_ex_class" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
               <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                  <td align="center">
					<cfif LEN(start_date) and LEN(finish_date)>
						<cfif ((datediff('n',now(),start_date) lte 15) and (datediff('n',now(),finish_date) gte 0)) and (online eq 1)>
							<a href="javascript://" onClick="windowopen('/COM_MX/onlineclass.swf?class_id=#class_id#&username=#session.ep.username#&server=#employee_domain#&appDirectory=#dsn#','project');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang no='25.Derse Katıl'>"></a>
						</cfif>
					</cfif>
				  </td>
				  <td>
						<cfset new_class_name = Replace(class_name,"'"," ","ALL")>
						<a href="javascript://" class="tableyazi"  onClick="add_class('#class_id#','#new_class_name#')">
						#class_name#
						</a>
				  </td>
				  <td>#CLASS_PLACE#</td>
                  <td>
				  	<cfset attributes.class_id = class_id>
					<cfif TYPE IS 'İÇ'>
						<cfinclude template="../query/get_class_trainer.cfm">
					<cfelseif TYPE IS 'DIŞ'>
						<cfinclude template="../query/get_ex_class_trainer.cfm">
					</cfif>
					
				    <cfif isDefined('GET_CLASS_TRAINER_EMP') and GET_CLASS_TRAINER_EMP.RECORDCOUNT>
					  #GET_CLASS_TRAINER_EMP.EMPLOYEE_NAME# #GET_CLASS_TRAINER_EMP.EMPLOYEE_SURNAME#
					</cfif>
					<cfif isDefined('GET_CLASS_TRAINER_PAR') and GET_CLASS_TRAINER_PAR.RECORDCOUNT>
					  #GET_CLASS_TRAINER_PAR.COMPANY_PARTNER_NAME# #GET_CLASS_TRAINER_PAR.COMPANY_PARTNER_SURNAME# - #GET_CLASS_TRAINER_PAR.NICKNAME#
					</cfif>
				  </td>
            	  <td>
					<cfif LEN(start_date) AND start_date GT '1/1/1900' and LEN(finish_date) AND finish_date GT '1/1/1900'>
						<cfif dateformat(start_date,dateformat_style) eq dateformat(now(),dateformat_style) or dateformat(finish_date,dateformat_style) eq dateformat(now(),dateformat_style) ><font  color="##FF0000"> </cfif>
						  <cfset startdate = date_add('h', session.ep.time_zone, start_date)>
						  <cfset finishdate = date_add('h', session.ep.time_zone, finish_date)>
						#dateformat(startdate,dateformat_style)# (#timeformat(startdate,timeformat_style)#) - #dateformat(finishdate,dateformat_style)# (#timeformat(finishdate,timeformat_style)#) 
					<cfelseif LEN(CLASS_DATE) AND CLASS_DATE GT '1/1/1900'>
						#dateformat(CLASS_DATE,dateformat_style)#
					<cfelseif LEN(MONTH_ID) AND MONTH_ID>
						#ListGetAt(my_month_list,MONTH_ID)# - #SESSION.EP.PERIOD_YEAR#
					</cfif>
					</cfoutput> 
              <cfelse>
				  </td>

              <tr class="color-row" height="20"> 
                <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
              </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
	<cfif attributes.totalrecords gt attributes.maxrows>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr> 
          <td height="35">
		  <cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="training_management.list_class#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>
    </td>
  </tr>
</table>

<script type="text/javascript">
function add_class(class_id,class_name)
{
	<cfif isdefined("attributes.field_id")>
	opener.<cfoutput>#field_id#</cfoutput>.value = class_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
	opener.<cfoutput>#field_name#</cfoutput>.value = class_name;
	</cfif>
	window.close();
}
</script>
