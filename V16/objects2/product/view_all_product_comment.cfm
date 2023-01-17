<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN3#">
	SELECT 
		PRODUCT_ID,
        NAME,
        SURNAME,
        PRODUCT_COMMENT_POINT,
        PRODUCT_COMMENT
	FROM
		PRODUCT_COMMENT
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		STAGE_ID = -2
	ORDER BY
		RECORD_DATE DESC
</cfquery>

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

<cfinclude template="../query/get_product_name.cfm">

<table align="center" cellpadding="2" cellspacing="1" border="0"  style="width:100%; height:100%;">
	<tr>
		<cfif get_product_vote.recordcount>
			<td colspan="2" style="width:200px; vertical-align:top;">
				<table>
					<tr>
						<td style="vertical-align:top;">
					  		<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="flash" chartwidth="500" chartheight="200">
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
	</tr>
	<cfif isdefined('attributes.is_product_comment') and attributes.is_product_comment eq 1 or (isdefined('attributes.is_product_comment') and attributes.is_product_comment eq 2 and isdefined('session_base.userid'))>
		<tr style="height:35px;">
			<td class="product_name"><b><cfoutput>#get_product_name.product_name#</cfoutput></b></td>
		  	<td  style="text-align:right;"><!---<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_product_comment&pid=#attributes.product_id#</cfoutput>','large');" class="tableyazi"><cf_get_lang no='359.rne Yorum Ekle'></a>---></td>
		</tr>
	</cfif>
  	<tr>
		<td colspan="2" style="vertical-align:top;"> 
	 		<table style="width:100%;">
	  			<cfif get_product_comment.recordcount>
					<cfoutput query="get_product_comment">
                        <tr class="color-row">
                            <td class="product_name">#name# #surname#<!--- - (<a href="mailto:#mail_address#" class="label">#mail_address#</a>)---></td>
                        </tr>
                        <tr class="color-row">
                            <td><strong><cf_get_lang_main no='1572.Puan'> : </strong> #product_comment_point#</td>
						</tr>
						<tr>
		  					<td>#product_comment#</td>
						</tr>			      
		 			</cfoutput>
				<cfelse>
			 		<tr> 
						<td><cf_get_lang no='388.�r�ne Yorum Eklenmemis'>.</td>
			  		</tr>
				</cfif>
		  	</table>
		</td>
	</tr>
</table>

