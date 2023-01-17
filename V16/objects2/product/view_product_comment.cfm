<cfif isdefined("attributes.pid")>
	<cfset attributes.product_id = #attributes.pid#>
</cfif>

<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN3#">
	SELECT 
		NAME,
        SURNAME,
        PRODUCT_COMMENT_POINT,
        PRODUCT_COMMENT,
        RECORD_DATE
	FROM
		PRODUCT_COMMENT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		STAGE_ID = -2
	ORDER BY
		RECORD_DATE DESC
</cfquery>

<cfif isdefined('attributes.is_comment_graph') and attributes.is_comment_graph eq 1>
	<cfquery name="GET_PRODUCT_VOTE" datasource="#DSN3#">
		SELECT 
			PRODUCT_COMMENT_POINT,
			COUNT(PRODUCT_COMMENT_POINT) AS PUAN
		FROM 
			PRODUCT_COMMENT 
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
			STAGE_ID = -2
		GROUP BY 
			PRODUCT_COMMENT_POINT
	</cfquery>
</cfif>

<cfif get_product_comment.recordcount>
	<table align="center" cellpadding="2" cellspacing="1" border="0" style="width:100%; height:100%;">
		<tr>
			<cfif isdefined('attributes.is_comment_graph') and attributes.is_comment_graph eq 1>
				<cfif get_product_vote.recordcount>
					<td colspan="2" style="width:200px; vertical-align:top;">
						<table>
							<tr>
								<td style="vertical-align:top;">
									<cfchart show3d="yes" labelformat="number"  pieslicestyle="solid" format="jpg" chartwidth="500" chartheight="200">
									<cfchartseries type="horizontalbar" itemcolumn="puan" paintstyle="light">
									  	<cfoutput query="get_product_vote">
											<cfchartdata item="#product_comment_point# Puan" value="#puan#">
									  	</cfoutput>
									</cfchartseries>
								  	</cfchart>
								</td>
							</tr>
						</table>
					</td>
				</cfif>
			</cfif>
		</tr>
		<cfif isdefined('attributes.my_add_product_comment') and (attributes.my_add_product_comment eq 1 or (attributes.my_add_product_comment eq 2 and isdefined('session_base.userid')))>
			<tr height="20">
				<td  style="text-align:right;">
					<div style="position:absolute;display:none;margin-left:-300;height:300;width:300;" id="<cfoutput>is_add_comment_#attributes.product_id#</cfoutput>"></div>
					<a href="javascript://" onClick="goster(<cfoutput>is_add_comment_#attributes.product_id#</cfoutput>);open_process();" class="tableyazi"><cf_get_lang no='359.Ürüne Yorum Ekle'></a>
			 	</td>
			</tr>
		</cfif>
		<cfif get_product_comment.recordcount>
			<cfoutput query="get_product_comment">
		   		<tr>
					<td>
						<table class="color-border" cellpadding="2" cellspacing="1" border="0" style="width:100%;">
                            <tr <cfif currentrow mod 2>class="color-list"<cfelse>class="color-row"</cfif>>
                                <td style="vertical-align:top;">
                                    <table style="width:100%;">
                                        <tr>
                                            <td><b>#name# #surname#</b> - #product_comment#</td>
                                        </tr>
                                        <cfif isdefined('attributes.is_comment_point') and attributes.is_comment_point eq 1>
                                            <tr>
                                                <td><strong><cf_get_lang_main no='1572.PUAN'> : </strong> #product_comment_point#</td>
                                            </tr>
                                        </cfif>
                                        <cfif isdefined('session.pp.time_zone')>
                                            <tr>
                                                <td>#dateformat(date_add('h',session.pp.time_zone,record_date),'dd/mm/yyyy')#, #timeformat(date_add('h',session.pp.time_zone,record_date),'HH:mm')#</td>
                                            </tr>
                                        <cfelseif isdefined('session.ww.time_zone')>
                                            <tr>
                                                <td>#dateformat(date_add('h',session.ww.time_zone,record_date),'dd/mm/yyyy')#, #timeformat(date_add('h',session.ww.time_zone,record_date),'HH:mm')#</td>
                                            </tr>
                                        </cfif>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </cfoutput>
			<tr>
				<td  style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_view_all_product_comment&product_id=#attributes.product_id#','large');" class="object_all"></a>&nbsp;(#get_product_comment.recordcount#</cfoutput><cf_get_lang no ='1375.yorum yapıldı'> )</td>
	 		</tr>
		<cfelse>
			<tr> 
				<td><cf_get_lang no='388.Ürüne Yorum Eklenmemiş'>.</td>
		  	</tr>
		</cfif>
   </table>
	<cfif isdefined('attributes.my_add_product_comment') and (attributes.my_add_product_comment eq 1 or (attributes.my_add_product_comment eq 2 and isdefined('session_base.userid')))>
		<script language="javascript1.1">
			function open_process()
			{
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.popup_add_product_comment&pid='+#attributes.product_id#+'','is_add_comment_#attributes.product_id#</cfoutput>',1);
			}
		</script>
	</cfif>
</cfif>
