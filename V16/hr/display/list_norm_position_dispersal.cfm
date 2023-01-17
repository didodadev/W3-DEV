<cfparam name="attributes.sal_mon" default="#dateformat(now(),'MM')#">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.position_cat_type" default="0">
<cfparam name="attributes.branch_status" default="1">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfquery name="get_branches" datasource="#DSN#">
	SELECT
		RELATED_COMPANY,
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE 
		<cfif len(attributes.branch_status)>BRANCH_STATUS = #attributes.branch_status# AND</cfif>
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY,
		BRANCH_NAME
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT
	
		WHERE
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			POSITION_CAT LIKE '%#attributes.keyword#%' AND
			</cfif>
			POSITION_CAT_STATUS =1
	ORDER BY 
		POSITION_CAT 
</cfquery>
<script type="text/javascript">
function showBranches()
{
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.emptypopup_get_branches&b_status=";
		var tmp = document.norm_position.branch_status.value;
        send_address += tmp;
		AjaxPageLoad(send_address,'BRANCH_PLACE');
}

function control()
{	
	if (document.norm_position.branch_id.value == '')
	{
		alert("<cf_get_lang dictionary_id='30126.Şube Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
<cfsavecontent variable="message"> <cf_get_lang dictionary_id="30126.Şube Seçiniz"></cfsavecontent>
<cf_big_list_search title="#message#">
<table style="text-align:right;">
    <cfform name="norm_position" action="#request.self#?fuseaction=hr.list_norm_position_dispersal" method="post">
    <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
    <tr>
        <td><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></td>
        <td>
            <select name="position_cat_type" id="position_cat_type">
                <option value=""><cf_get_lang dictionary_id ='58081.Hepsi'></option>
                <option value="1" <cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58573.Merkez'></option>
                <option value="0" <cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57453.Şube'></option>
            </select>
        </td>
        <!---<td>
            <select name="branch_status" onChange="showBranches();">
                <option value=""><cf_get_lang_main no ='296.Tümü'></option>
                <option value="1" <cfif attributes.branch_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
                <option value="0" <cfif attributes.branch_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
            </select>
        </td>--->
        <td><div id="BRANCH_PLACE">
            <select name="branch_id" id="branch_id">
                <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                <cfoutput query="get_branches" group="RELATED_COMPANY">
                        <optgroup label="#RELATED_COMPANY#"></optgroup>
                    <cfoutput>
                        <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                    </cfoutput>
                </cfoutput>
            </select>
            </div>
        </td>
        <td><select name="POSITION_CAT_ID" id="POSITION_CAT_ID" style="width:150px;">
                <option value=""><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></option>
            <cfoutput query="get_position_cats_">
                <option value="#position_cat_id#" <cfif isdefined("attributes.POSITION_CAT_ID") and attributes.POSITION_CAT_ID eq position_cat_id>selected</cfif>>#position_cat#</option>
            </cfoutput>
            </select>
        </td>
        <td>
        <select name="sal_mon" id="sal_mon">
            <cfloop from="1" to="12" index="i">
              <cfoutput><option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option></cfoutput><!---  --->
            </cfloop>
        </select>
      </td>
      <td><input name="sal_year" id="sal_year" type="text" value="<cfoutput>#attributes.sal_year#</cfoutput>" readonly style="width:50px;"></td>
      <td valign="bottom"><cf_wrk_search_button search_function='control()'></td>
    </tr>
    </cfform>
</table>
</cf_big_list_search>
<cfif isdefined("attributes.is_form_submit")>
<cfquery name="get_departments" datasource="#dsn#">
	SELECT DISTINCT
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID 
	FROM 
		DEPARTMENT D,
		BRANCH B
	WHERE 
		B.BRANCH_ID = #attributes.branch_id# AND
		D.BRANCH_ID = B.BRANCH_ID
	ORDER BY
		D.DEPARTMENT_HEAD
</cfquery>

<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>

<cfquery name="get_branch_dept_positions_1" datasource="#dsn#">
	SELECT DISTINCT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		EP.POSITION_CAT_ID,
		EP.POSITION_ID,
		EP.EMPLOYEE_ID
	FROM 
		DEPARTMENT D,
		EMPLOYEE_POSITIONS_HISTORY EP,
		BRANCH B 
	WHERE		
		EP.EMPLOYEE_ID IN (SELECT EIO.EMPLOYEE_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND D.BRANCH_ID = EIO.BRANCH_ID AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= #puantaj_finish_#)) AND
		EP.EMPLOYEE_ID > 0 AND
		EP.POSITION_STATUS = 1 AND
		D.DEPARTMENT_STATUS = 1 AND
		D.IS_STORE <> 1 AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.BRANCH_ID = #attributes.branch_id# AND
		(
		(EP.FINISH_DATE >= #puantaj_finish_#)
		OR
		EP.FINISH_DATE IS NULL
		OR
		EP.FINISH_DATE = ''
		)
	ORDER BY
		EP.POSITION_ID DESC
</cfquery>


<cfquery name="get_branch_dept_positions" dbtype="query">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		POSITION_CAT_ID,
		COUNT(POSITION_ID) AS CALISAN_SAYISI
	FROM
		get_branch_dept_positions_1
	GROUP BY
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		POSITION_CAT_ID
</cfquery>


<cfquery name="get_old_values" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_NORM_POSITIONS WHERE BRANCH_ID = #attributes.branch_id# AND NORM_YEAR = #attributes.sal_year#
</cfquery>

<cfloop from="1" to="12" index="i">
	<cfset 'norm_position_list_#i#' = ''>
	<cfset 'norm_count_list_#i#' = ''>
</cfloop>
<cfoutput query="get_old_values">
	<cfif len(detail)>
		<cfset 'detail_#POSITION_CAT_ID#' = detail>
	</cfif>
	<cfloop from="1" to="12" index="i">
		<cfif len(evaluate("EMPLOYEE_COUNT#i#"))>
			<cfset 'deger_#i#_' = evaluate("EMPLOYEE_COUNT#i#")>
		<cfelse>
			<cfset 'deger_#i#_' = 0>
		</cfif>
		<cfset 'norm_position_list_#i#' = listappend(evaluate("norm_position_list_#i#"),POSITION_CAT_ID)> 
		<cfset 'norm_count_list_#i#' = listappend(evaluate("norm_count_list_#i#"),evaluate("deger_#i#_"))>
	</cfloop>
</cfoutput>

<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT 
		SPC.*,
		SDN.DEPARTMENT_NAME
	FROM 
		SETUP_POSITION_CAT SPC,
		SETUP_POSITION_CAT_DEPARTMENTS SPCD,
		SETUP_DEPARTMENT_NAME SDN
	WHERE
		SPC.POSITION_CAT_ID = SPCD.POSITION_CAT_ID AND
		SPCD.DEPARTMENT_NAME_ID = SDN.DEPARTMENT_NAME_ID AND
		<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
			SPC.POSITION_CAT_ID = #attributes.POSITION_CAT_ID# AND
		</cfif>
		<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>
			SPC.POSITION_CAT_TYPE = 1 AND
		</cfif>
		<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>
			SPC.POSITION_CAT_UPPER_TYPE = 1 AND
		</cfif>
		SPC.POSITION_CAT_STATUS = 1 AND
		SPC.POSITION_CAT_ID IS NOT NULL
		UNION
			SELECT
				*,
				' ' AS DEPARTMENT_NAME
			FROM
				SETUP_POSITION_CAT
			WHERE
		 		<cfif isdefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
					POSITION_CAT_ID = #attributes.POSITION_CAT_ID# AND
				</cfif>
				<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 0>
					POSITION_CAT_TYPE = 1 AND
				</cfif>
		 		<cfif isdefined("attributes.position_cat_type") and attributes.position_cat_type eq 1>
					POSITION_CAT_UPPER_TYPE = 1 AND
		 		</cfif>
				POSITION_CAT_ID NOT IN (SELECT POSITION_CAT_ID FROM SETUP_POSITION_CAT_DEPARTMENTS) AND
				POSITION_CAT_STATUS = 1 AND
				POSITION_CAT_ID IS NOT NULL
		ORDER BY
			DEPARTMENT_NAME
</cfquery>

<cfset position_cat_id_list = ''>
<cfset calisan_list = ''>
<cfoutput query="get_branch_dept_positions">
	<cfset position_cat_id_list = listappend(position_cat_id_list,'#POSITION_CAT_ID#-#DEPARTMENT_ID#')>
	<cfset calisan_list = listappend(calisan_list,CALISAN_SAYISI)>
</cfoutput>
<table cellspacing="1" cellpadding="2" width="98%" border="0" align="center" class="color-border">
    <cfform name="add_norm" action="#request.self#?fuseaction=hr.emptypopup_add_norm_position_cat" method="post">
    <input type="hidden" name="position_cat_id_list" id="position_cat_id_list" value="<cfoutput>#valuelist(GET_POSITION_CATS.POSITION_CAT_ID)#</cfoutput>">
    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
    <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#attributes.position_cat_id#</cfoutput>">
    <input type="hidden" name="position_cat_type" id="position_cat_type" value="<cfoutput>#attributes.position_cat_type#</cfoutput>">
    <input type="hidden" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>">
    <input type="hidden" name="sal_mon" id="sal_mon" value="<cfoutput>#attributes.sal_mon#</cfoutput>">
    <tr class="color-header" height="22">
        <td class="form-title"  width="100%" nowrap><cf_get_lang dictionary_id ='56551.Norm Kadro Bilgileri'></td>
        <cfloop from="1" to="12" index="i">
            <td class="form-title" width="25" nowrap="nowrap" align="right"><cfoutput>#listgetat(ay_list(),i)#</cfoutput></td>
        </cfloop>
        <td class="color-row"></td>
        <cfoutput query="get_departments"><td class="form-title" nowrap="nowrap" style="text-align:right;">#department_head#</td></cfoutput>
        <td class="form-title" width="25" align="center">T</td>
        <td class="form-title" width="25" align="center">F</td>
        <td class="form-title" width="125"><cf_get_lang_main no ='217.Açıklama'></td>
    </tr>
    <tr class="color-list">
        <td class="txtbold">&nbsp;</td>
        <cfloop from="1" to="12" index="i">
            <td class="txtbold" width="25" align="center"><cfoutput>#i#</cfoutput></td>
        </cfloop>
        <td class="color-header"></td>
        <cfoutput query="get_departments">
        <td class="txtbold" width="25" align="center">G</td>
        </cfoutput>
        <td class="txtbold" width="25" align="center">T</td>
        <td class="txtbold" width="25" align="center" bgcolor="red">F</td>
        <td>&nbsp;</td>
    </tr>
    <cfset genel_toplam = 0>
    <cfset fark_toplam = 0>
    <cfloop from="1" to="12" index="i">
        <cfset 'ongorulen_genel_ay_toplam_#i#' = 0>
    </cfloop>
    <cfset count_dept = 0>
    <cfoutput query="GET_POSITION_CATS" group="DEPARTMENT_NAME">
    <cfset count_dept = count_dept + 1>
        <tr height="20" class="color-list">
            <td colspan="#18+get_departments.recordcount#" class="txtbold">#DEPARTMENT_NAME#</td>
        </tr>
        <cfset ara_toplam = 0>
        <cfset ara_fark_toplam = 0>
        <cfset count_ = 0>
        <cfloop query="get_departments">
            <cfset count_ = count_ + 1>
            <cfset 'ara_dept_toplam_#count_#' = 0>
        </cfloop>
        
        <cfloop from="1" to="12" index="i">
            <cfset 'ongorulen_ay_toplam_#i#' = 0>
        </cfloop>				
        
        <cfoutput>
        <cfset this_cat_id_ = POSITION_CAT_ID>
        <cfset toplam_ = 0>
        <tr height="20" onMouseOver="this.bgColor='#colorlist#';" onMouseOut="this.bgColor='#colorrow#';" bgcolor="#colorrow#">
            <td>#position_cat#</td>
            <cfloop from="1" to="12" index="i">
                <cfset a = evaluate("norm_position_list_#i#")>
                <cfset b = evaluate("norm_count_list_#i#")>
                <cfif listfindnocase(a,this_cat_id_)>
                    <cfset ongorulen_ = listgetat(b,listfindnocase(a,this_cat_id_))>
                <cfelse>
                    <cfset ongorulen_ = 0>
                </cfif>
                <td width="25" align="center" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>><input type="text" name="ongorulen_#GET_POSITION_CATS.POSITION_CAT_ID#_#i#_#count_dept#" id="ongorulen_#GET_POSITION_CATS.POSITION_CAT_ID#_#i#_#count_dept#" value="#ongorulen_#" style="width:25px;" class="moneybox" onFocus="change_son_deger('#GET_POSITION_CATS.POSITION_CAT_ID#','#i#','#count_dept#');" onkeyup="return(FormatCurrency(this,event,0));" onBlur="uygula('#GET_POSITION_CATS.POSITION_CAT_ID#','#i#','#count_dept#')"></td>
                <cfif i eq attributes.sal_mon>
                    <cfset ongorulen_asil_ = ongorulen_>
                </cfif>
                <cfset 'ongorulen_ay_toplam_#i#' = evaluate('ongorulen_ay_toplam_#i#') + ongorulen_>
                <cfset 'ongorulen_genel_ay_toplam_#i#' = evaluate('ongorulen_genel_ay_toplam_#i#') + ongorulen_>
            </cfloop>
            <td class="color-header"></td>
            <cfset count_ = 0>
            <cfloop query="get_departments">
            <cfset count_ = count_ + 1>
                <cfif listlen(position_cat_id_list) and listfindnocase(position_cat_id_list,'#this_cat_id_#-#get_departments.DEPARTMENT_ID#')>
                    <cfset sira_ = listfindnocase(position_cat_id_list,'#this_cat_id_#-#get_departments.DEPARTMENT_ID#')>
                    <cfset gerceklesen_ = listgetat(calisan_list,sira_)>
                <cfelse>
                    <cfset gerceklesen_ = 0>
                </cfif>
                <cfset toplam_ = toplam_ + gerceklesen_>
                <cfif isdefined("dept_toplam_#count_#")>
                    <cfset 'dept_toplam_#count_#' = evaluate("dept_toplam_#count_#") + gerceklesen_>
                <cfelse>
                    <cfset 'dept_toplam_#count_#' = gerceklesen_>
                </cfif>
                <cfset 'ara_dept_toplam_#count_#' = evaluate("ara_dept_toplam_#count_#") + gerceklesen_>
                <td title="#get_departments.department_head# - Gerçekleşen" <cfif gerceklesen_ gt 0>class="color-border"</cfif>>
                    <cfif gerceklesen_ gt 0>
                        <input type="text" value="#gerceklesen_#" style="width:25px;" readonly class="moneybox" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_norm_position_dispersal_positions&position_cat_id=#this_cat_id_#&sal_year=#attributes.sal_year#&sal_mon=#attributes.sal_mon#&branch_id=#attributes.branch_id#','list');" style="cursor:pointer;">
                    <cfelse>
                        <input type="text" value="#gerceklesen_#" style="width:25px;" readonly class="moneybox">
                    </cfif>
                </td>
            </cfloop>
            <cfset fark_toplam = fark_toplam + (ongorulen_asil_ - toplam_)>
            <cfset genel_toplam = genel_toplam + toplam_>
            <cfset ara_fark_toplam = ara_fark_toplam + (ongorulen_asil_ - toplam_)>
            <cfset ara_toplam = ara_toplam + toplam_>
            <td title="#position_cat# - Toplam" class="color-header"><input type="text" value="#toplam_#" style="width:25px;" readonly class="moneybox" name="satir_toplam_#GET_POSITION_CATS.POSITION_CAT_ID#" id="satir_toplam_#GET_POSITION_CATS.POSITION_CAT_ID#"></td>
            <td title="#position_cat# - Fark" bgcolor="red"><input type="text" value="#ongorulen_asil_ - toplam_#" style="width:25px;" readonly class="moneybox" name="satir_fark_#GET_POSITION_CATS.POSITION_CAT_ID#" id="satir_fark_#GET_POSITION_CATS.POSITION_CAT_ID#"></td>
            <td><input type="text" maxlength="250" value="<cfif isdefined('detail_#POSITION_CAT_ID#')>#evaluate('detail_#POSITION_CAT_ID#')#</cfif>" style="width:115px;" name="detail_#GET_POSITION_CATS.POSITION_CAT_ID#" id="detail_#GET_POSITION_CATS.POSITION_CAT_ID#"></td>
        </tr>
        </cfoutput>
        <tr height="20" class="color-list">
            <td><font color="red">#DEPARTMENT_NAME# <cf_get_lang_main no='1247.Toplamı'></font></td>
            <cfloop from="1" to="12" index="i">
                <td width="25" align="center" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>><input type="text"  name="departman_#count_dept#_#i#" id="departman_#count_dept#_#i#" value="#evaluate('ongorulen_ay_toplam_#i#')#" style="width:25px;" class="moneybox"></td>
            </cfloop>
            <td class="color-header"></td>
            <cfset count_ = 0>
            <cfloop query="get_departments">
                <cfset count_ = count_ + 1>
                <td width="25" align="center"><input type="text" value="#evaluate('ara_dept_toplam_#count_#')#" style="width:25px;" readonly class="moneybox"></td>
            </cfloop>
            <td style="text-align:right;" class="color-header"  title="#department_name# - Toplam"><input type="text" value="#ara_toplam#" style="width:25px;" readonly class="moneybox" name="departman_toplam_#count_dept#" id="departman_toplam_#count_dept#"></td>
            <td style="text-align:right;" bgcolor="red" title="#department_name# - Fark"><input type="text" value="#ara_fark_toplam#" style="width:25px;" readonly class="moneybox" name="departman_fark_#count_dept#" id="departman_fark_#count_dept#"></td>
            <td>&nbsp;</td>
        </tr>
        <tr height="1">
            <td colspan="#17+get_departments.recordcount#"></td>
        </tr>
    </cfoutput>
    <cfoutput>
        <tr class="color-list">
        <td class="txtbold">&nbsp;</td>
        <cfloop from="1" to="12" index="i">
                <td width="25" align="center" nowrap <cfif i eq attributes.sal_mon>class="color-header"</cfif>><input type="text" value="#evaluate('ongorulen_genel_ay_toplam_#i#')#" style="width:25px;" readonly class="moneybox" name="son_departman_toplam_#i#" id="son_departman_toplam_#i#"></td>
            </cfloop>
        <td class="color-header"></td>
        <cfset count_ = 0>
        <cfloop query="get_departments">
            <cfset count_ = count_ + 1>
            <cfif isdefined('dept_toplam_#currentrow#')>
            <td width="25" style="text-align:right;" class="txtbold" style="text-align:right;">#evaluate('dept_toplam_#currentrow#')#</td>
            <cfelse>
            <td width="25"  class="txtbold" style="text-align:right;">0</td>
            </cfif>
        </cfloop>
        <td width="25"  class="txtbold" style="text-align:right;"><input type="text" value="#genel_toplam#" style="width:25px;" readonly class="moneybox" name="genel_toplam" id="genel_toplam"></td>
        <td width="25"  bgcolor="red" class="txtbold" style="text-align:right;"><input type="text" value="#fark_toplam#" style="width:25px;" readonly class="moneybox" name="toplam_fark" id="toplam_fark"></td>
        <td>&nbsp;</td>
    </tr>
    </cfoutput>
    <tr height="25" class="color-row">
        <td colspan="<cfoutput>#17+count_#</cfoutput>"  style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' type_format="1"></td>
    </tr>
    <input type="hidden" name="dept_count" id="dept_count" value="<cfoutput>#count_dept#</cfoutput>">
    </cfform>
</table><br />
</cfif>
<script type="text/javascript">
var son_deger_ = 0;
function uygula(category,ilgili_ay,dept_no)
{
	asil_ay = <cfoutput>#attributes.sal_mon#</cfoutput>;
	
	deger_ = eval("document.add_norm.ongorulen_"+category+"_"+ilgili_ay+"_"+dept_no).value;
	if(deger_=='')
		deger_ = 0;
		
	toplam_degisim_ = 0;
	for(var i=1; i<13; i++)
		{
		if(ilgili_ay <= i)
			{
			if(ilgili_ay < i)
				{
				gelen_tutar_ = eval("document.add_norm.ongorulen_"+category+"_"+i+"_"+dept_no).value;
				}
			else
				{
				gelen_tutar_ = son_deger_;
				}
				
			if(gelen_tutar_=='')
				gelen_tutar_ = 0; 
			degisim_ = parseInt(deger_ - gelen_tutar_);
			toplam_degisim_ = parseInt(toplam_degisim_ + degisim_);
			x = eval("document.add_norm.departman_"+dept_no+"_"+i).value;
			eval("document.add_norm.ongorulen_"+category+"_"+i+"_"+dept_no).value = deger_;
			eval("document.add_norm.departman_"+dept_no+"_"+i).value = parseInt(x) + parseInt(degisim_);
			eval("document.add_norm.son_departman_toplam_"+i).value = parseInt(eval("document.add_norm.son_departman_toplam_"+i).value) + degisim_;
			}
		
		if(asil_ay==i)
			{
			gelen_tutar_ = parseInt(eval("document.add_norm.ongorulen_"+category+"_"+i+"_"+dept_no).value);
			eval("document.add_norm.satir_fark_"+category).value = parseInt(eval("document.add_norm.ongorulen_"+category+"_"+i+"_"+dept_no).value) - parseInt(eval("document.add_norm.satir_toplam_"+category).value);
			eval("document.add_norm.departman_fark_"+dept_no).value = parseInt(eval("document.add_norm.departman_"+dept_no+"_"+i).value) - parseInt(eval("document.add_norm.departman_toplam_"+dept_no).value);
			}
		}
	document.add_norm.toplam_fark.value = parseInt(document.add_norm.son_departman_toplam_<cfoutput>#attributes.sal_mon#</cfoutput>.value) - parseInt(document.add_norm.genel_toplam.value);
}

function change_son_deger(category,ilgili_ay,dept_no)
{
	son_deger_ = eval("document.add_norm.ongorulen_"+category+"_"+ilgili_ay+"_"+dept_no).value;
}
</script>
