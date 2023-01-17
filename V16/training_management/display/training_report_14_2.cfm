<table cellpadding="0" cellspacing="0" style="height:260mm;width:187mm;" align="center" border="0" bordercolor="#CCCCCC">
	<tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
	</tr>
<tr>
<td valign="top" height="100%">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <cfif isdefined("attributes.kapak_bas")>
    <tr>
	   <td class="headbold" height="35" align="center"><font color="##CC0099"><cfoutput>#attributes.kapak_bas#</cfoutput></font></td>
	</tr>
   <cfelse>
  <tr>
    <td class="headbold" height="35" align="center">
	<font color="#CC0000"><cf_get_lang no='325.Eğitimcinin Katılımcıları Değerlendirmesi'></font></td>
  </tr>
  </cfif>
  
</table>
  <table width="100%" cellpadding="0" cellspacing="0" border="1" bordercolor="CCCCCC">
	  <tr>
		<td>Eğitim</td>
		<td class="txtbold"><cf_get_lang no='225.Seminere Ilgi'></td>
		<td class="txtbold"><cf_get_lang no='226.Tartismalara Katilim'></td>
		<td class="txtbold"><cf_get_lang no='227.Ögrenme Motivasyonu'></td>
		<td class="txtbold"><cf_get_lang no='228.Fikir Üretme'></td>
		<td class="txtbold"><cf_get_lang no='229.Karsi Fikre Saygi'></td>
		<td class="txtbold"><cf_get_lang no='230.Yenilige Açiklik'></td>
		<td class="txtbold"><cf_get_lang no='231.Degisime Inanç'></td>
		<td class="txtbold"><cf_get_lang_main no='678.Iletisim Becerisi'></td>
	  </tr>
			
		<cfloop list="#attributes.class_id_list#" index="i">
	     <cfset attributes.class_id= i>
	    <cfinclude template="../query/get_report_queries.cfm">
	    <cfinclude template="../query/get_upd_class_queries.cfm">	
			 <cfinclude template="../query/get_class.cfm">
             <cfset attributes.quiz_id = get_class.quiz_id>
            <cfquery name="GET_CLASS_ATTENDER_EVAL" datasource="#dsn#">
	         SELECT
		        AVG(SEMINERE_ILGI) AS SEMINERE_ILGI
                ,AVG(TARTISMALARA_KATILIM) AS TARTISMALARA_KATILIM
               ,AVG(OGRENME_MOTIVASYONU) AS OGRENME_MOTIVASYONU
		       ,AVG(FIKIR_URETME) AS FIKIR_URETME                        
		       ,AVG(KARSI_FIKRE_SAYGI) AS KARSI_FIKRE_SAYGI
		       ,AVG(YENILIGE_ACIKLIK) AS YENILIGE_ACIKLIK                        
               ,AVG(DEGISIME_INANC) AS DEGISIME_INANC                
		       ,AVG(ILETISIM_BECERISI) AS ILETISIM_BECERISI                        
	         FROM
		        TRAINING_CLASS_ATTENDER_EVAL
	         WHERE
		        CLASS_ID = #attributes.CLASS_ID#
            </cfquery>
          <cfquery name="get_emp_att" datasource="#dsn#">
            SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
          </cfquery>
			  <cfoutput query="GET_CLASS_ATTENDER_EVAL">
                  
                <tr height="20">
				   <td>&nbsp;#get_class.class_name#</td>
                  <td>#SEMINERE_ILGI#&nbsp;</td>
                  <td>#TARTISMALARA_KATILIM#&nbsp;</td>
                  <td>#OGRENME_MOTIVASYONU#&nbsp;</td>
                  <td>#FIKIR_URETME#&nbsp;</td>
                  <td>#KARSI_FIKRE_SAYGI#&nbsp;</td>
                  <td>#YENILIGE_ACIKLIK#&nbsp;</td>
                  <td>#DEGISIME_INANC#&nbsp;</td>
                  <td>#ILETISIM_BECERISI#&nbsp;</td>
                </tr>
              </cfoutput>
		 </cfloop>
              <tr height="20">
                <td height="20" colspan="2" class="txtbold" style="text-align:right;"> 1 = <cf_get_lang no='233.Çok Zayif'>&nbsp;&nbsp;&nbsp; 2 = <cf_get_lang no='234.Zayif&nbsp'>;&nbsp;&nbsp; 3 = <cf_get_lang_main no='516.Orta&nbsp'>;&nbsp;&nbsp; 4 = <cf_get_lang no='236.Iyi'>&nbsp;&nbsp;&nbsp; 5 = <cf_get_lang no='237.Çok Iyi'> </td>
              </tr>
            </table>
</td>
</tr>
	 <tr>
	<td align="center"><cfinclude template="../../objects/display/view_company_info.cfm"></td>
	</tr>
</table>
