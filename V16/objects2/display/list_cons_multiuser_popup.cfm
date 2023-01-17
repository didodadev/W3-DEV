<!--- 
İki tip kullanımı vardır.
-------------------------
1.
Açan penceredeki istenen alana seçilenleri kaydeder !
	to_title: hangi baslik atilacak custom tag icin kullanilir bu
	field_id: 			consumer_id
	field_name:			consumer adı ve soyadı
	field_comp_name:	consumer 'ın şirket full adı
	field_address:		consumer 'ın iş adresi
	field_type:			"consumer"
örnek kullanım :
	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_cons_multiuser&field_id=form1.aaa&field_name=form1.bbb&field_comp_id=form1.aaa&field_comp_name=form1.aaa&field_name=form1.aaa&camp_id=2&select_list=2,1,3,4,5,6','list');"> Gidecekler </a>
2.
Açan penceredeki ilgili listeye yeni kişi eklemek için kullanılır ! Url_direction da belirtilen fuseaction'a başta con_id ler olmak üzere hidden inputları gönderir.
	url_direction: 		Submit edilecek yer.. bu adrese url_params eklenecek ve bunun içinde fuseaction hariç diğer url parametrelerinin ismi yazacak virgülle ayrılmış vaziyette
						(Örnek: campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id)
örnek kullanım :
	<cfset url_direction = 'campaign.emptypopup_add_list&cmp_id=111&asd_id=222&url_params=cmp_id,asd_id'>
	<a href="//" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons_multiuser&url_direction=#url_direction#</cfoutput>','list')"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='170.Ekle'>" align="center" border="0"> </a>
	Submit edilen con_id input'unun ismi attributes.con_ids dir ve içinde virgülle ayrılmış bir liste olarak kişileri tutmaktadır. 
	Ayrıca eğer select_list içinde birden fazla numara varsa o zaman submit edilen değerlerin hangisine ait olduğu hidden input "member_type" ile belirlenir.
	Submit edilen input'lar:
		<input type="checkbox" value="#consumer_id#" name="con_ids">
		<input type="hidden" name="consumer_name" value="#consumer_name#">
		<input type="hidden" name="consumer_surname" value="#consumer_surname#">
		<input type="hidden" name="company" value="#company#">
		<input type="hidden" name="stradres" value="#stradres#">
		<input type="hidden" name="member_type" value="consumer">
	Revizyon:09012003 Arzu BT
	id bilgileriniğ forma gonderirken asagidaki yapida gonderecektir.orn:employee icin emp-employee_id ile birlestirerek.
	EMP-id  employeer icin
	PAR-id partner id icin 
	POS-id position_id icin(employeer position)
	CON-id consumer id icin
	GRP-id group id icin 
	WRK-id	bu yok sanirsam	
--->
<cfif fusebox.fuseaction contains "popup_list_all_cons">
	<cfparam name="attributes.type" default="">
<cfelseif fusebox.fuseaction contains "popup_list_pot_cons">
	<cfparam name="attributes.type" default="1">
<cfelseif fusebox.fuseaction contains "popup_list_my_cons">
	<cfparam name="attributes.type" default="2">
<cfelse>
	<cfparam name="attributes.type" default="0">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../../objects/query/get_consumers.cfm">
<cfelse>
	<cfset get_consumers.recordcount="0">
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME FROM SETUP_CITY
</cfquery>
<cfquery name="GET_COUNTY" datasource="#DSN#">
	SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY 
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_consumers.recordcount#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.select_list" default="1,2,3,4,5,6,7,8">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
    	<cfif isdefined("attributes.to_title") and len(attributes.to_title)>to_title = <cfoutput>#attributes.to_title#</cfoutput>;<cfelse>to_title=1;</cfif>
    	function add_checked()
		{
			<cfif isdefined("attributes.row_count")>
				rowCount = parseInt(opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value);
			</cfif>
			var counter = 0;
			<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
				for(i=0;i<document.form_name.con_ids.length;i++) 
					if (document.form_name.con_ids[i].checked == true)
					{
						counter = counter + 1;
					}
				if (counter == 0)
				{
					alert("cf_get_lang no ='221.Kişi seçmelisiniz'>!");
					return false;
				}
			<cfelseif get_consumers.recordcount eq 1 or  attributes.maxrows eq 1>
				if (document.getElementById('con_ids').checked == true)
				{
					counter = counter + 1;
					con_ids_ =  document.getElementById('con_ids').value;
				}
				if (counter == 0)
				{
					alert("<cf_get_lang no ='221.Kişi seçmelisiniz'>!");
					return false;
				}
			</cfif>
			<cfif get_consumers.recordcount gt 1 and isdefined("attributes.field_cons_id") and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.con_ids.length;i++)
				{
					if (document.form_name.con_ids[i].checked == true)
					{
						counter = counter + 1;
						var con_id = document.form_name.con_ids[i].value;
						var con_name = document.form_name.consumer_name[i].value+' '+document.form_name.consumer_surname[i].value;				
						rowCount = rowCount + 1;
						var ss_int=ekle_str(con_name,con_id);
					}
				}
				opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			<cfelseif (get_consumers.recordcount eq 1 or  attributes.maxrows eq 1 ) and isdefined("attributes.field_cons_id")>
				var con_ids = document.getElementById('con_ids').value;
				var con_name = document.getElementById('consumer_name').value+' '+document.getElementById('consumer_surname').value;
				rowCount = rowCount + 1;
				var ss_int=ekle_str(con_name,con_ids);
				opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;
			</cfif>
			<cfif get_consumers.recordcount gt 1 and isdefined("attributes.field_address") and attributes.maxrows neq 1>	
				counter = 0;
				for(i=0;i<document.form_name.con_ids.length;i++) 
					if (fdocument.orm_name.con_ids[i].checked == true)
					{
						counter = counter + 1;
						var address = document.form_name.stradres[i].value;
						if (counter == 1)
						{
							var addresses = address;
						}
						else
						{
							var addresses = addresses + ',' + address;
						}
					}
					opener.<cfoutput>#attributes.field_address#</cfoutput>.value = addresses;
			<cfelseif (get_consumers.recordcount eq 1  or  attributes.maxrows eq 1 ) and isdefined("attributes.field_address")>
				var addresses = document.getElementById('stradres').value;
				opener.<cfoutput>#attributes.field_address#</cfoutput>.value = addresses;
			</cfif>
				
			<cfif isdefined("attributes.field_type")>
				opener.<cfoutput>#attributes.field_type#</cfoutput>.value = "consumer";
			</cfif>
			<cfif isDefined("attributes.url_direction")>
				<cfoutput>
					document.form_name.action='#request.self#?fuseaction=#attributes.url_direction#&' + document.getElementById('url_string').value;
				</cfoutput>
				document.form_name.submit();
			<cfelse>
				/*window.close();*/
			</cfif>
		}
		<cfif isdefined("attributes.table_name")>
			function ekle_str(str_ekle,int_id)
			{
				var newRow;
				var newCell;
				<cfoutput>
					newRow = opener.document.all.#attributes.table_name#.insertRow();
					newRow.setAttribute("name","#attributes.table_row_name#" + rowCount);
					newRow.setAttribute("id","#attributes.table_row_name#" + rowCount);		
					newRow.setAttribute("style","display:''");	
					newCell = newRow.insertCell(newRow.cells.length);
					str_html = '';
					
					<cfif isdefined("attributes.field_cons_id")>
						str_html = str_html + '<input type="hidden" name="#attributes.field_cons_id#" id="#attributes.field_cons_id#" value="' + int_id + '">'
					</cfif>
					str_html = str_html +'<input type="hidden" name="#attributes.field_grp_id#" id="#attributes.field_grp_id#" value=""><input type="hidden" name="#attributes.field_wgrp_id#" id="#attributes.field_wgrp_id#" value="">';
					str_del='<a href="javascript://" onClick="#attributes.function_row_name#(' + rowCount +','+int_id+');"><img src="/images/delete_list.gif"  align="absmiddle" border="0"></a>&nbsp;';	
					newCell.innerHTML = str_del + str_html + str_ekle  ;
				</cfoutput>
				return 1;
			}
		</cfif>	
	</script>
</cfif>

<cfset url_string = "">
<cfif IsDefined("attributes.url_params") and Len(attributes.url_params)>
	<cfloop list="#attributes.url_params#" index="urlparam">
		<cfset url_string = "#url_string#&#urlparam#=#evaluate('attributes.'&urlparam)#">
	</cfloop>
</cfif>

<cfif isDefined('attributes.table_name') and len(attributes.table_name)>
	<cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
</cfif>
<cfif isDefined('attributes.table_row_name') and len(attributes.table_row_name)>
	<cfset url_string = '#url_string#&table_row_name=#attributes.table_row_name#'>
</cfif>
<cfif isDefined('attributes.field_grp_id') and len(attributes.field_grp_id)>
	<cfset url_string = '#url_string#&field_grp_id=#attributes.field_grp_id#'>
</cfif>
<cfif isdefined('attributes.field_wgrp_id') and len(attributes.field_wgrp_id)>
	<cfset url_string = '#url_string#&field_wgrp_id=#attributes.field_wgrp_id#'>
</cfif>
<cfif isdefined('attributes.function_row_name') and len(attributes.function_row_name)>
	<cfset url_string = '#url_string#&function_row_name=#attributes.function_row_name#'>
</cfif>
<cfif len(attributes.select_list)>
	<cfset url_string = '#url_string#&select_list=#attributes.select_list#'>
</cfif>
<cfif isdefined('attributes.row_count') and len(attributes.row_count)>
	<cfset url_string = '#url_string#&row_count=#attributes.row_count#'>
</cfif>
<cfif isdefined('attributes.field_cons_id') and len(attributes.field_cons_id)>
	<cfset url_string = '#url_string#&field_cons_id=#attributes.field_cons_id#'>
</cfif>
<cfif isDefined('attributes.field_company_id') and len(attributes.field_company_id)>
	<cfset url_string = '#url_string#&field_company_id=#attributes.field_company_id#'>
</cfif>
<cfif isdefined('attributes.field_par_id') and len(attributes.field_par_id)>
	<cfset url_string = '#url_string#&field_par_id=#attributes.field_par_id#'>
</cfif>

<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:100%">
	<tr class="color-row">
		<cfoutput> 
            <td>&nbsp;</td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=A">A</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=B">B</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=C">C</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ç">Ç</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=D">D</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=E">E</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=F">F</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=G">G</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ğ">Ğ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=H">H</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=I">I</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=İ">İ</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=J">J</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=K">K</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=L">L</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=M">M</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=N">N</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=O">O</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ö">Ö</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=P">P</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Q">Q</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=R">R</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=S">S</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ş">Ş</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=T">T</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=U">U</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Ü">Ü</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=V">V</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=W">W</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Y">Y</a></td>
            <td align="center" style="width:15px;"><a class="tableyazi" href="#request.self#?fuseaction=#attributes.fuseaction##url_string#&form_submit=1&keyword=Z">Z</a></td>
            <td>&nbsp;</td>
        </cfoutput>
	</tr>
</table>

<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>

<cfform name="search_con" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
	<input type="hidden" name="form_submit" id="form_submit" value="1">
    <table align="center" cellpadding="0" cellspacing="0" style="width:98%; height:35px;">
        <tr>
            <td class="headbold">
                <cfoutput>
                    <select name="categories" id="categories" onchange="location.href=this.value;">
						<cfif ListFind(attributes.select_list,1)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_positions_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_positions_multiuser'>selected</cfif>><cf_get_lang_main no='1463.Çalışanlar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,2)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>>C. <cf_get_lang_main no='173.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,3)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_cons_multiuser'>selected</cfif>>C. <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,4)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_grps_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_grps_multiuser'>selected</cfif>><cf_get_lang no='326.Gruplar'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,5)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_cons_multiuser'>selected</cfif>>P <cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,6)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pot_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pot_pars_multiuser'>selected</cfif>>P <cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,7)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_pars_multiuser'>selected</cfif>><cf_get_lang_main no='1611.Kurumsal Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,8)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_all_cons_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_all_cons_multiuser'>selected</cfif>><cf_get_lang_main no='1609.Bireysel Üyeler'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,9)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_pars_multiuser#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_pars_multiuser'>selected</cfif>><cf_get_lang no='281.Kurumsal Üyemin Çalışanları'></option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,10)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_pars#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_pars'>selected</cfif>>Kurumsal Üyelerim</option>
                        </cfif>
                        <cfif ListFind(attributes.select_list,11)>
                            <option value="#request.self#?fuseaction=objects2.popup_list_my_cons#url_string#" <cfif attributes.fuseaction eq 'objects2.popup_list_my_cons'>selected</cfif>>Bireysel Üyelerim</option>
                        </cfif>
                    </select>
                </cfoutput>
            </td>
            <td class="headbold">
                <table align="right">
                    <tr>
                        <td><cf_get_lang_main no='48.Filtre'></td>
                        <td><input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="255"></td>
                            <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
                                SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT WHERE IS_ACTIVE = 1 ORDER BY CONSCAT
                            </cfquery>
                        <td>
                        <select name="consumer_cat" id="consumer_cat" style="width:120px;">
                            <option value=""><cf_get_lang_main no='1535.Kategori'></option>
                            <cfoutput query="get_consumer_cat">
                                <option value="#get_consumer_cat.conscat_id#" <cfif isdefined("attributes.consumer_cat") and attributes.consumer_cat eq get_consumer_cat.conscat_id>selected</cfif>>#get_consumer_cat.conscat#</option>
                            </cfoutput>
                        </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                        <td><a href="javascript:history.go(-1);"><img src="/images/back.gif" title="<cf_get_lang_main no='20.Geri'>"></a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>

<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:98%">
    <tr class="color-header" style="height:22px;"> 
        <th class="form-title" style="width:35px;"><cf_get_lang_main no='75.No'></th>
        <th class="form-title"><cf_get_lang_main no='158.Ad Soyad'></th>
        <th class="form-title"><cf_get_lang_main no='74.kategori'></th>
        <th class="form-title"><cf_get_lang_main no='162.Şirket'></th>
        <cfif attributes.fuseaction contains 'multiuser'>
            <th class="form-title" style="width:15px;">
				<cfif get_consumers.recordcount>
                	<input type="Checkbox" id="all" name="all" value="1" onclick="javascript: hepsi();">
                </cfif>
            </th>
        </cfif>
    </tr>

	<!--- <cfif isdefined("attributes.form_submit")> --->
    <cfif get_consumers.recordcount>
        <form action="" method="post" name="form_name">
			<cfoutput query="get_consumers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td>#consumer_id#</td>
                    <td>
                    	<cfif attributes.fuseaction contains 'multiuser'>
							<cfif len(work_city_id)>
                                <cfquery name="GET_CITY_NAME" dbtype="query">
                                    SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_city_id#">
                                </cfquery>
                                <cfset value_city_name = get_city_name.city_name>
                            <cfelse>
                                <cfset value_city_name = ''>	
                            </cfif>
                            <cfif len(work_county_id)>
                                <cfquery name="GET_COUNTY_NAME" dbtype="query">
                                    SELECT COUNTY_NAME FROM GET_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_county_id#">
                                </cfquery>
                                <cfset value_county_name = get_county_name.county_name>
                            <cfelse>
                                <cfset value_county_name = ''>
                            </cfif>
                            <cfset stradres="#workaddress# #workpostcode# #value_county_name# #value_city_name#">
                            <cfset stradres = Replace(stradres,Chr(13)," ","ALL")>
                            <cfset stradres = Replace(stradres,Chr(10)," ","ALL")>
                            <!--- <a href="javascript://" onClick="add_user('#consumer_id#','#consumer_name# #consumer_surname#','#company#','#stradres#')" class="tableyazi">  --->
                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium')">#consumer_name# #consumer_surname#</a>
                            <!--- </a> --->
                        <cfelse>
                         	<a href="javascript://" onclick="load_member('#consumer_name# #consumer_surname#','#consumer_id#');" class="tableyazi">#consumer_name# #consumer_surname#</a>                       
                        </cfif>
                    </td>
                    <td>#conscat#</td>
                    <td>#company#</td>
                    <cfif attributes.fuseaction contains 'multiuser'>
                        <td>
                            <input type="checkbox" name="con_ids" id="con_ids" value="#consumer_id#">
                            <input type="hidden" name="consumer_name" id="consumer_name" value="#consumer_name#">
                            <input type="hidden" name="consumer_surname" id="consumer_surname" value="#consumer_surname#">
                            <input type="hidden" name="company" id="company" value="#company#">
                            <input type="hidden" name="stradres" id="stradres" value="#stradres#">
                        </td>
                    </cfif>
                </tr>
            </cfoutput>
            <cfif attributes.fuseaction contains 'multiuser'>
                <tr class="color-list">
                    <td style="text-align:right;" colspan="8"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onclick="add_checked();"></td>
                </tr>				
            </cfif>
            <input type="hidden" name="member_type" id="member_type" value="consumer">
            <input type="hidden" name="url_string" id="url_string" value="<cfoutput>#url_string#</cfoutput>">					
        </form>
    <cfelse>
        <tr class="color-row" style="height:20px;">
            <td colspan="7"><cfif isdefined("attributes.form_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
        </tr>
    </cfif>
</table>

<cfif isdefined("attributes.consumer_cat") and len(attributes.consumer_cat)>
	<cfset url_string = "#url_string#&consumer_cat=#attributes.consumer_cat#">
</cfif>

<cfif attributes.maxrows lt attributes.totalrecords>
	<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:99%; height:35px;">
		<tr>
			<td> <cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##url_string#&form_submit=1"> </td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.form_submit")>
		function hepsi()
		{
			if (document.getElementById('all').checked)
			{
				<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.con_ids.length;i++) document.form_name.con_ids[i].checked = true;
				<cfelseif get_consumers.recordcount eq 1  or  attributes.maxrows eq 1>
					document.getElementById('con_ids').checked = true;
				</cfif>
			}
			else
			{
				<cfif get_consumers.recordcount gt 1 and attributes.maxrows neq 1>	
					for(i=0;i<document.form_name.con_ids.length;i++) document.form_name.con_ids[i].checked = false;
				<cfelseif get_consumers.recordcount eq 1 or attributes.maxrows eq 1>
					document.getElementById('con_ids').checked = false;
				</cfif>
			}
		}
	</cfif>
	<cfif not attributes.fuseaction contains 'multiuser'>
		function load_member(consname, consid)
		{
			rowCount = 1;
			if(opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value == 1) 
			{
				var my_element = opener.document.getElementById('workcube_to_row1');
				my_element.parentNode.removeChild(my_element);
			}
			var ss_int = ekle_str(consname,consid);
			opener.document.all.<cfoutput>#attributes.row_count#</cfoutput>.value = 1;
			window.close();
		}
	</cfif>
	document.getElementById('keyword').focus();
</script>

