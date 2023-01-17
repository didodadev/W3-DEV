<cfquery name="GET_PRO_COMP" datasource="#DSN3#">
    SELECT 
        DETAIL,
        COMPETITIVE_ID,
		#dsn#.#dsn#.Get_Dynamic_Language(COMPETITIVE_ID,'#session.ep.language#','PRODUCT_COMP','COMPETITIVE',NULL,NULL,COMPETITIVE) AS COMPETITIVE
    FROM 
        PRODUCT_COMP
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37018.Fiyat Yetki Tanımları'></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#message#">
<cf_grid_list>
	<thead>
		<tr>
			<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="125"><cf_get_lang dictionary_id='58233.Tanım'></th>
			<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
			<th class="header_icn_none">
			<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.list_product_comp&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_pro_comp.recordcount>
			<cfoutput query="get_pro_comp">
			<tr>
				<td>#GET_PRO_COMP.Currentrow#</td>
				<td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.list_product_comp&event=upd&ID=#COMPETITIVE_ID#');"> #COMPETITIVE# </a></td>
				<td>
					<cfquery name="GET_IDS" datasource="#DSN3#">
						SELECT
							POSITION_CODE,
							PARTNER_ID
						FROM
							PRODUCT_COMP_PERM
						WHERE
							PRODUCT_COMP_PERM.COMPETITIVE_ID = #COMPETITIVE_ID#
					</cfquery>
					<cfloop query="GET_IDS">
						<cfif len(POSITION_CODE)>
							<cfquery name="get_emp_name" datasource="#DSN#">
								SELECT
									EMPLOYEE_ID,
									EMPLOYEE_NAME,
									EMPLOYEE_SURNAME
								FROM
									EMPLOYEE_POSITIONS
								WHERE
									POSITION_CODE = #POSITION_CODE#
							</cfquery>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp_name.EMPLOYEE_ID#');">#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#</a>
							,
						<cfelse>
							<cfquery name="GET_PAR_NAME" datasource="#DSN#">
							SELECT
								COMPANY_PARTNER_NAME,
								COMPANY_PARTNER_SURNAME
							FROM
								COMPANY_PARTNER
							WHERE
								PARTNER_ID = #PARTNER_ID#
							</cfquery>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#');">#GET_PAR_NAME.COMPANY_PARTNER_NAME# #GET_PAR_NAME.COMPANY_PARTNER_SURNAME# ,</a>
						</cfif>
					</cfloop>
				</td>
				<td align="center">
					<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_product_comp&event=upd&ID=#COMPETITIVE_ID#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
					</a>
				</td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>
</cf_box>
</div>

