<cfinclude template="../../../project/query/get_project_graph.cfm">

<cfscript>
start_x_list = '';
start_y_list = '';
end_x_list = '';
end_y_list = '';
work_list = valuelist(get_graph.work_id);
new_list = '';

function QueryRowFromKey(theQuery, keyField, keyFieldValue)
{
	var key_field_value_list = Evaluate('ValueList(theQuery.#keyField#)');
	return ListFindNoCase(key_field_value_list, keyFieldValue);
}

function get_ups(eleman2)
{
	SQLQuery = 'SELECT WORK_ID FROM PRO_WORK_RELATIONS WHERE PRE_ID = #ELEMAN2#';
	query_list = cfquery(SQLString : SQLQuery, Datasource : DSN);
	return valuelist(query_list.work_id, ',');
}

function ups(eleman1)
{
	up_list = get_ups(eleman1);
	while (listlen(up_list))
		{
		alt_eleman = listgetat(up_list, 1, ',');
		new_list = listappend(new_list, alt_eleman, ',');
		if (listfindnocase(work_list, alt_eleman))
			work_list = listdeleteat(work_list, listfindnocase(work_list, alt_eleman), ',');
		ups(alt_eleman);
		}
}
/* tarih sırası için bu kısım kapansa kafi */
if ((not isdefined('form.sort_type')) or (isdefined('form.sort_type') and (form.sort_type eq 1)))
	{
	while (listlen(work_list, ','))
		{
		eleman = listgetat(work_list, 1, ',');
		new_list = listappend(new_list, eleman, ',');
		if (listfindnocase(work_list,eleman))
			work_list = listdeleteat(work_list, listfindnocase(work_list,eleman), ',');
		ups(eleman);
		}
	work_list = new_list;
	}
/* // tarih sırası için bu kısım kapansa kafi */

if (isdefined('form.carpan'))
	{
	carpan = form.carpan;
	}
else
	{
	carpan = 1;
	}
// bir gün 30 pixel

x = 260;
y = 20;
counter = 0;
height = 10;
koridor = 35;

startday = dayofweek(GET_PRO_HEAD.target_start)-2;
if (startday eq -1) startday = 7;
fark = ( (startday * 24) + timeformat(GET_PRO_HEAD.target_start,'HH') ) * carpan;

PRO_LEN = (DATEDIFF('h', GET_PRO_HEAD.target_start, GET_PRO_HEAD.target_finish) * carpan) + fark; 

SQLQuery = 'SELECT PRIORITY_ID, COLOR FROM SETUP_PRIORITY';
priorities = cfquery(SQLString : SQLQuery, Datasource : DSN);
if (carpan eq 1)
	{
	back_img = 'graphback100.gif';
	week_img = 'graphtakvim100.gif';
	}
else if (carpan eq 0.1)
	{
	back_img = 'graphback10.gif';
	week_img = 'graphtakvim10.gif';
	}
else if (carpan eq 0.25)
	{
	back_img = 'graphback25.gif';
	week_img = 'graphtakvim25.gif';
	}
else if (carpan eq 0.5)
	{
	back_img = 'graphback50.gif';
	week_img = 'graphtakvim50.gif';
	}
else if (carpan eq 0.75)
	{
	back_img = 'graphback75.gif';
	week_img = 'graphtakvim75.gif';
	}
else if (carpan eq 1.5)
	{
	back_img = 'graphback150.gif';
	week_img = 'graphtakvim150.gif';
	}
else if (carpan eq 2)
	{
	back_img = 'graphback200.gif';
	week_img = 'graphtakvim200.gif';
	}
</cfscript>

<cfoutput>
<DIV id="project_layer" style="margin: 0px; padding: 0px; border: 0px;left:#x#px; top:0px; width:#pro_len#px; height:#evaluate(listlen(work_list)*50+15)#px; z-index:-99999; position:absolute; cursor : hand;" class="label">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" background="/images/#back_img#">
	<tr>
		<td></td>
	</tr>
</table>
</DIV>
<DIV id="gunler_fon" style="margin: 0px; padding: 0px; left:#x#px; top:0px; width:#pro_len#px; position:absolute; border: none; z-index:99999;" class="label"> 
<table class="txtbold" width="100%" height="20" cellpadding="0" cellspacing="0">
	<tr>
		<td background="/images/#week_img#"></td>
	</tr>
</table>
</DIV>
<DIV id="start_date_layer" style="margin: 0px; padding: 0px; left:#x+fark#px; top:0px; width:150px; position:absolute; border: none; z-index:99999;" class="label"> 
<table class="txtbold" width="100%" height="20" cellpadding="0" cellspacing="0">
	<tr>
		<td>#dateformat(GET_PRO_HEAD.target_start,'dd/mm/yyyy')#</td>
	</tr>
</table>
</DIV>
<DIV id="end_date_layer" style="margin: 0px; padding: 0px; left:#x+pro_len-80#px; top:0px; width:150px; position:absolute; border: none; z-index:99999;" class="label"> 
<table class="txtbold" width="100%" height="20" cellpadding="0" cellspacing="0">
	<tr>
		<td>#dateformat(GET_PRO_HEAD.target_finish,'dd/mm/yyyy')#</td>
	</tr>
</table>
</DIV>
<DIV id="img_#counter#_head" style="margin: 0px; padding: 0px; border: 0px;left:1px; top:0px; width:250px; height:25px; z-index:#1#; position:absolute;" class="label">
<table>
	<tr class="color-header" height="20">
		<td width="160" class="form-title">&nbsp;<cf_get_lang no ='680.İş Adı'></td>
		<td width="90" class="form-title">&nbsp;<cf_get_lang_main no ='164.Çalışan'></td>
	</tr>
</table>
</DIV>
</cfoutput>
<cfscript>
x = 260 + fark;

</cfscript>
<cfloop list="#work_list#" index="i" delimiters=",">
	<cfscript>
	query_index = QueryRowFromKey(get_graph, 'work_id', i);
	prior = (datediff('h', GET_PRO_HEAD.target_start, get_graph.TARGET_START[query_index])) * carpan;
	total = (datediff('h', get_graph.TARGET_START[query_index], get_graph.TARGET_FINISH[query_index])) * carpan;
	later = (datediff('h', get_graph.TARGET_FINISH[query_index], GET_PRO_HEAD.target_finish)) * carpan;
	left_x = x + prior;
	left_y = y + (counter*koridor);
	start_x_list = listappend(start_x_list, left_x);
	start_y_list = listappend(start_y_list, left_y);
	end_x_list 	= listappend(end_x_list, left_x + total);
	end_y_list 	= listappend(end_y_list, left_y + height);
	counter = counter + 1;
	bg_color = priorities.color[QueryRowFromKey(priorities, 'priority_id', get_graph.WORK_PRIORITY_ID[query_index])];
	</cfscript>
	
	<cfoutput>		
		<DIV id="img_#counter#_head" style="margin: 0px; padding: 0px; border: 0px;left:1px; top:#left_y#px; width:250px; height:#height#px; z-index:#evaluate(counter+15)#; position:absolute;" class="label">
			<table>
			<tr class="color-list">
			<td width="160"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&work_id=#encrypt(i,"WORKCUBE","BLOWFISH","Hex")#','large');">#left(get_graph.WORK_HEAD[query_index],30)#</a></td>
			<!---<cfif get_graph.position_code[query_index] neq 0>
				<td width="90">#left('#get_graph.EMPLOYEE_NAME[query_index]# #get_graph.EMPLOYEE_SURNAME[query_index]#',15)#</td>
			<cfelseif get_graph.partner_id[query_index] neq 0>
				<td width="90">#left('#get_graph.company_partner_NAME[query_index]# #get_graph.company_partner_SURNAME[query_index]#',15)#</td>
			</cfif>--->
			</tr>
			</table>
		</DIV>

		<DIV title="#get_graph.WORK_HEAD[query_index]##chr(13)##get_graph.EMPLOYEE_NAME[query_index]# #get_graph.EMPLOYEE_SURNAME[query_index]##chr(13)#(#dateformat(get_graph.target_start[query_index],'dd/mm/yyyy')# - #dateformat(get_graph.target_finish[query_index],'dd/mm/yyyy')#)" onClick="windowopen('#request.self#?fuseaction=objects2.popup_updwork&ID=#i#','large');" id="img_#counter#" style="left:#left_x#px; top:#left_y#px; width:#total#px; height:#height#px; z-index:#evaluate(counter+15)#; position:absolute; background-color: #bg_color#; layer-background-color: #bg_color#; cursor : hand;margin: 0px; padding: 0px; border: 0px;" class="label">
		<cfswitch expression="#get_graph.WORK_CURRENCY_ID[query_index]#">
			<cfcase value="1"><img src="/images/graphstart.gif" title="<cf_get_lang no ='1388.Başlamadı'>" border="0"></cfcase>
			<cfcase value="2"><img src="/images/graphcontinue.gif" title="<cf_get_lang no ='1387.Devam ediyor'>" border="0"></cfcase>
			<cfcase value="3"><img src="/images/graphstop.gif" title="<cf_get_lang no ='1386.Bitti'>" border="0"></cfcase>
		</cfswitch>
		</DIV>
	</cfoutput>
</cfloop>

<!--- bağlantılar çizilir --->
<cfoutput query="get_graph">
	<cfset attributes.pro_work_id = work_id>
	<cfset relation_index = 0>
	<cfinclude template="../query/get_relations.cfm">
	<cfloop query="get_relations">
		<cfscript>
		relation_index = relation_index + 1;
		pre_index = listfindNoCase(work_list, get_relations.pre_id[relation_index]);
		start_x = listgetat(end_x_list, pre_index);
		start_y = listgetat(end_y_list, pre_index);
		pre_x = listgetat(start_x_list, pre_index);
		pre_y = listgetat(start_y_list, pre_index);
		
		work_index = listfindNoCase(work_list, get_relations.work_id[relation_index]);
		end_x = listgetat(start_x_list, work_index)+(relation_index*3)+3;
		end_y = listgetat(start_y_list, work_index);
		work_x = listgetat(start_x_list, work_index);
		work_y = listgetat(start_y_list, work_index);
		
		height1 = abs(start_y-end_y)/2;
		height2 = abs(start_y-end_y)/2;
		
		if (height1 lte 15)
			fark = 5;
		else
			fark = 0;
		
		length = end_x-start_x;
		</cfscript>
<!--- çizgiler farklara göre çizilir --->
		<cfif start_x gt end_x>
			<cfif start_y gt end_y>
			<!--- üç aşamalı çizgi --->
				<!---1<br/>--->
				<!--- aşağı 1 --->
				<DIV style="left:#end_x#px; top:#end_y+15#px; width:1px; height:#evaluate(height1-15)#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
				<!--- düz çizgi --->
				<DIV style="left:#end_x#px; top:#evaluate(end_y+height1-7)#px; width:#evaluate(start_x-end_x)#px; height:#height#px; z-index:1002; position:absolute;margin: 0px; padding: 0px; border: 0px;"><HR width="100%" noshade color="red"></DIV>
				<!--- aşağı 2 --->
				<DIV style="left:#start_x#px; top:#evaluate(end_y+height1)#px; width:1px; height:#height2#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
			<cfelseif start_y lt end_y>
			<!--- üç aşamalı çizgi --->
				<!--- 2=4<br/>--->
				<!--- aşağı 1 --->
				<DIV style="left:#start_x#px; top:#start_y-fark#px; width:1px; height:#height1#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
				<!--- düz çizgi --->
				<DIV style="left:#end_x#px; top:#evaluate(start_y+height1-7)#px; width:#evaluate(start_x-end_x+1)#px; height:#height#px; z-index:1002; position:absolute;margin: 0px; padding: 0px; border: 0px;"><HR width="100%" noshade color="red"></DIV>
				<!--- aşağı 2 --->
				<DIV style="left:#end_x#px; top:#evaluate(start_y+height1)#px; width:1px; height:#height2#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
			</cfif>
		<cfelseif start_x lt end_x>
			<cfif start_y gt end_y>
			<!--- üç aşamalı çizgi --->
				<!---3<br/>--->
			<cfelseif start_y lt end_y>
			<!--- üç aşamalı çizgi --->
				<!--- 4=2<br/>--->
				<!--- aşağı 1 --->
				<DIV style="left:#start_x#px; top:#start_y-fark#px; width:1px; height:#height1#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
				<!--- düz çizgi --->
				<cfif end_x gt start_x>
					<DIV style="left:#start_x#px; top:#evaluate(start_y+height1-7)#px; width:#evaluate(end_x-start_x+1)#px; height:#height#px; z-index:1002; position:absolute;margin: 0px; padding: 0px; border: 0px;"><HR width="100%" noshade color="red"></DIV>
				<cfelse>
					<DIV style="left:#end_x#px; top:#evaluate(start_y+height1-7)#px; width:#evaluate(start_x-end_x+1)#px; height:#height#px; z-index:1002; position:absolute;margin: 0px; padding: 0px; border: 0px;"><HR width="100%" noshade color="red"></DIV>
				</cfif>
				<!--- aşağı 2 --->
				<DIV style="left:#end_x#px; top:#evaluate(start_y+height1)#px; width:1px; height:#height2#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
			</cfif>
		<cfelseif start_x eq end_x>
			<cfif start_y gt end_y>
			<!--- tek aşamalı çizgi --->
				<!---5<br/> --->
				<DIV style="left:#start_x#px; top:#end_y#px; width:1px; height:#evaluate(start_y-end_y)#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
			<cfelseif start_y lt end_y>
			<!--- tek aşamalı çizgi --->
				<!---6<br/> --->
				<DIV style="left:#start_x#px; top:#start_y#px; width:1px; height:#evaluate(end_y-start_y)#px; z-index:1001; position:absolute; background-color: red; layer-background-color: red;margin: 0px; padding: 0px; border: 0px;"></DIV>
			</cfif>
		</cfif>
	</cfloop>
</cfoutput>
