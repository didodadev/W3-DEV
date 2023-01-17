<cfif isdefined("attributes.keyword")>
	<cfquery name="get_department_rates" datasource="#dsn#">
		SELECT 
			ENPDR.*,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			B.BRANCH_ID
		FROM
			EMPLOYEE_NORM_POSITIONS_DEPT_RATE ENPDR,
			DEPARTMENT D,
			BRANCH B
		WHERE
			ENPDR.AVERAGE_RATE_YEAR = #attributes.norm_year# AND
			D.DEPARTMENT_HEAD LIKE '%#attributes.keyword#%' AND
			ENPDR.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID
		ORDER BY
			B.BRANCH_NAME,
			ENPDR.AVERAGE_RATE_YEAR DESC
	</cfquery>
<cfelse>
	<cfset get_department_rates.recordcount = 0>
</cfif>

<cfparam name="attributes.norm_year" default="#year("#now()#")#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_department_rates.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
        	<tr>
          		<td class="headbold"><cf_get_lang dictionary_id='55211.Norm Kadrolar'><cf_get_lang dictionary_id="35277.Departman Oranları"></td>
		  		<!-- sil -->
          		<td  valign="bottom" style="text-align:right;">
            	<table>
              	<cfform name="search" action="#request.self#?fuseaction=hr.list_norm_position_department_rate" method="post">
                	<tr>
                 		<td><cf_get_lang dictionary_id='57460.Filtre'> :</td>
						<td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
						<td>
							<cfset bu_yil = "#year("#now()#")#">
							<select name="norm_year" id="norm_year">
							<cfoutput>
							<cfloop from="-2" to="3" index="i">
							<cfset deger=bu_yil+i>
								<option value="#deger#" <cfif attributes.norm_year eq deger>selected</cfif>>#deger#</option>
							</cfloop>
							</cfoutput>
							</select>
						</td>
                  		<td>
                    		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    		<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
       					</td>
                  		<td><cf_wrk_search_button></td>
                  		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</tr>
				</cfform>
				</table>
          		</td>
		  	<!-- sil -->
			</tr>
     	</table>
		<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
			<tr class="color-header" height="22">
				<td class="form-title" width="50"><cf_get_lang dictionary_id='57487.No'></td>
				<td class="form-title" width="150"><cf_get_lang dictionary_id='57453.Şube'></td>
				<td class="form-title" width="150"><cf_get_lang dictionary_id="57572.Departman</td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57592.Ocak"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57593.Şubat"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57594.Mart"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57595.Nisan"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57596.Mayıs"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57597.Haziran"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57598.Temmuz"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57599.Ağustos"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57600.Eylül"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57601.Ekim"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57602.Kasım"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="57603.Aralık"></td>
				<td  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="58455.Yıl"></td>
				<!-- sil -->
				<td width="15"><a href="<cfoutput>#request.self#?fuseaction=hr.add_norm_position_department_rate</cfoutput>"><img src="/images/plus_square.gif" align="Ekle" border="0"></a></td>
				<!-- sil -->
			</tr>
			<cfif get_department_rates.recordcount>
				<cfoutput query="get_department_rates" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td>#BRANCH_NAME#</td>
						<td>#DEPARTMENT_HEAD#</td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_1)>#tlformat(AVERAGE_RATE_1,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_2)>#tlformat(AVERAGE_RATE_2,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_3)>#tlformat(AVERAGE_RATE_3,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_4)>#tlformat(AVERAGE_RATE_4,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_5)>#tlformat(AVERAGE_RATE_5,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_6)>#tlformat(AVERAGE_RATE_6,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_7)>#tlformat(AVERAGE_RATE_7,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_8)>#tlformat(AVERAGE_RATE_8,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_9)>#tlformat(AVERAGE_RATE_9,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_10)>#tlformat(AVERAGE_RATE_10,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_11)>#tlformat(AVERAGE_RATE_11,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;"><cfif len(AVERAGE_RATE_12)>#tlformat(AVERAGE_RATE_12,6)#<cfelse>-</cfif></td>
						<td  style="text-align:right;">#AVERAGE_RATE_YEAR#</td>
						<!-- sil -->
						<td width="15"><a href="#request.self#?fuseaction=hr.add_norm_position_department_rate&branch_id=#branch_id#&norm_year=#AVERAGE_RATE_YEAR#"><img src="/images/update_list.gif" align="Güncelle" border="0"></a></td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
					<td colspan="17"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</table>
		<cfif attributes.totalrecords gt attributes.maxrows>
    	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
        	<tr>
            	<td>
					<cf_pages page="#attributes.page#"
			  		maxrows="#attributes.maxrows#"
			  		totalrecords="#attributes.totalrecords#"
			  		startrow="#attributes.startrow#"
			  		adres="hr.list_norm_position_department_rate&keyword=#attributes.keyword#&norm_year=#attributes.norm_year#">
				</td>
            	<!-- sil -->
				<td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_department_rates.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
			</tr>
		</table>
	</cfif>
