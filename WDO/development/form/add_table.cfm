<!--- <cfquery datasource="#dsn#" name="get_catalog_name">
	SELECT DISTINCT(DB_NAME) AS DB_NAME FROM WRK_OBJECT_INFORMATION
</cfquery>   --->
<form name="create_table_" action="http://ep.workcube/index.cfm?fuseaction=dev.create_new_table" onsubmit="return form_control()" method="post">
<cf_form_box title="Tablo Oluştur" nofooter="1">
<table>
    <tr>
        <td width="100"></td>
        <td width="200"><input type="checkbox" name="type" id="type" checked="checked" disabled="disabled"/>Active</td><input name="type" id="type" type="hidden" value="1" />
    </tr>
    <tr>
        <td>Hangi Db</td>
        <td>
            <select name="database_name" id="database_name" style="width:151px;">
                <option value="workcube_cf">Workcube_Main_Db</option>
                <option value="workcube_cf_1">Workcube_Company_Dd</option>
                <option value="workcube_cf_2012_1">Workcube_Period_Db</option>
                <option value="workcube_cf_product">Workcube_Product_Db</option>
            </select>
        </td>
        <td>Status</td>
        <td>
            <select name="status" id="status" style="width:123px;"> 
                <option value="Deployment" >Deployment</option>
                <option value="Development">Development</option>
            </select> 
        </td>
    </tr>
    <tr>
        <td>Tablo Adi</td>
        <td><input name="table_name_" id="table_name_" type="text" style="width:150px;" value="" /></td>
        <td>Version</td>
        <td><input type="text" id="version" value="V.12" name="version" /></td>
    </tr>
    <tr>
        <td valign="top">Description(tr)*</td>
        <td>
            <textarea name="table_info" rows="5" style="width:150px;" id="table_info"></textarea>
        </td>
        <td valign="top">Description(Eng)</td>
        <td>
            <textarea name="table_info_eng" rows="5" style="width:150px;" id="table_info_eng"></textarea>
        </td>
    </tr>
</table>
<br />
<cf_form_list>
	<thead>
        <tr>
            <th><i class="fa fa-plus fa-lg btnPointer" onclick="add_row();"></i><input type="hidden" name="record_num" id="record_num" value="6" /></td>
            <th>Alan Adı</th>
            <th>Alan Türü</th>
            <th>Uzunluk</th>
            <th>Boş Geçilebilsin mi?</th>
            <th>Otomatik Arttır</th>
            <th>Varsayılan Değer</th>
            <th>Açıklama(tr)*</th>
            <th>Açıklama(eng)</th>
    	</tr>
    </thead>
    <tbody id="link_table">
        <tr id="my_row_0">
            <td><a style="cursor:pointer" onclick="return sil(0);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" id="column_name0" value="" name="column_name0"  />
                <input  type="hidden"  value="1" name="row_kontrol_0" id="row_kontrol_0"/>
                <input type="hidden" value="1" name="control_0" id="control_0" />	
            </td>
            <td>
                <select style="width:68px;" id="data_type0"  name="data_type0" onchange="type_control(this.value,0);">							
                    <option  value="int">int</option>							
                </select>
            </td>
            <td><input type="text" value="" name="length0" id="length0"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" name="is_null0" id="is_null0"/></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" value="1" onblur="SadeceRakam(event,false)" name="start0" id="start0"/>, Artış<input type="text" readonly="readonly" name="increment0"   onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  value="1" style="width:20px;" id="increment0" /></td>
            <td><input type="text" name="default_value0" id="default_value0" /></td>
            <td><input type="text" value="Identity Alan" name="column_info0" id="column_info0"  /></td>
            <td><input type="text" value="Identity Column" name="column_info_eng0" id="column_info_eng0"  /></td>													
        </tr>
        <tr id="my_row_1">
            <td><a style="cursor:pointer" onclick="return sil(1);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" value="RECORD_DATE" id="column_name1" name="column_name1"/>
                <input  type="hidden"  value="1"  name="row_kontrol_1" id="row_kontrol_1"/>	
                <input type="hidden" value="1" name="control_1" id="control_1" />
            </td>
            <td>
                <select id="data_type1" name="data_type1" onchange="type_control(this.value,1);">
                    <option value="datetime">datetime</option>
                </select>
            </td>
            <td><input type="text" value="" name="length1" id="length1"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null1" id="is_null1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly" name="start1"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" id="start1"/>, Artış<input type="text" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" name="increment1"  style="width:20px;" id="increment1" /></td>
            <td><input type="text" name="default_value1" id="default_value1" value="" /></td>
            <td><input type="text" name="column_info1" id="column_info1" value="Kayıt Tarihi" /></td>
            <td><input type="text" name="column_info_eng1" id="column_info_eng1" value="Record Date" /></td>
        </tr>
        <tr id="my_row_2">
            <td><a style="cursor:pointer" onclick="return sil(2);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" value="RECORD_EMP" name="column_name2" id="column_name2"/>
                <input  type="hidden"  value="1" name="row_kontrol_2" id="row_kontrol_2"/>
                <input type="hidden" value="1" name="control_2" id="control_2" />
            </td>
            <td>
                <select style="width:68px;" id="data_type2" name="data_type2" onchange="type_control(this.value,2);">
                    <option value="int">int</option>
                </select>
            </td>
            <td><input type="text" value="" name="length2" id="length2"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null2" id="is_null2" value="1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  name="start2" id="start2" />, Artış<input type="text" name="increment2"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" id="increment2" /></td>
            <td><input type="text" name="default_value2" id="default_value2" /></td>
            <td><input type="text" name="column_info2" value="Kayıtı'ı Yapan Çalışan" id="column_info2" /></td>
            <td><input type="text" name="column_info_eng2" value="Record Employee" id="column_info_eng2" /></td>
        </tr>
        <tr id="my_row_3">
            <td><a style="cursor:pointer" onclick="return sil(3);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" id="column_name3" value="RECORD_IP" name="column_name3"/>
                <input  type="hidden"  value="1" id="row_kontrol_3"  name="row_kontrol_3"/>
                <input type="hidden" value="1" name="control_3" id="control_3" />
            </td>
            <td>
                <select id="data_type3" name="data_type3" onchange="type_control(this.value,3);">
                    <option value="nvarchar">nvarchar</option>
                </select>
            </td>
            <td><input type="text" value="50" name="length3" id="length3"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null3" id="is_null3" value="1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  name="start3" id="start3" />, Artış<input type="text" name="increment3"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" id="increment3" /></td>
            <td><input type="text" name="default_value3" id="default_value3" /></td>
            <td><input type="text" name="column_info3" value="Kayıt yapan IP" id="column_info3" /></td>
            <td><input type="text" name="column_info_eng3" value="Record Ip" id="column_info_eng3" /></td>
        </tr>
        <tr id="my_row_4">
            <td><a style="cursor:pointer" onclick="return sil(4);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" id="column_name4" value="UPDATE_DATE" name="column_name4"/>
                <input  type="hidden"  value="1" id="row_kontrol_4"  name="row_kontrol_4"/>
                <input type="hidden" value="1" name="control_4" id="control_4" />
            </td>
            <td>
                <select id="data_type4" name="data_type4" onchange="type_control(this.value,4);">
                    <option value="datetime">datetime</option>
                </select>
            </td>
            <td><input type="text" value="" name="length4" id="length4"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null4" id="is_null4" value="1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  name="start4" id="start4" />, Artış<input type="text" name="increment4"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" id="increment4" /></td>
            <td><input type="text" name="default_value4" value="" id="default_value4" /></td>
            <td><input type="text" name="column_info4" value="Güncelleme Tarihi" id="column_info4" /></td>
            <td><input type="text" name="column_info_eng4" value="Update Ip" id="column_info_eng4" /></td>
        </tr>
        <tr id="my_row_5">
            <td><a style="cursor:pointer" onclick="return sil(5);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" id="column_name5" value="UPDATE_EMP" name="column_name5"/>
                <input  type="hidden"  value="1" id="row_kontrol_5"  name="row_kontrol_5"/>
                <input type="hidden" value="1" name="control_5" id="control_5" />
            </td>
            <td>
                <select style="width:68px;" id="data_type5" name="data_type5" onchange="type_control(this.value,5);">
                    <option value="int">int</option>
                </select>
            </td>
            <td><input type="text" value="" name="length5" id="length5"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null5" id="is_null5" value="1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  name="start5" id="start5" />, Artış<input type="text" name="increment5"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" id="increment5" /></td>
            <td><input type="text" name="default_value5" id="default_value5" /></td>
            <td><input type="text" name="column_info5" value="Güncelleyen Çalışan"  id="column_info5" /></td>
            <td><input type="text" name="column_info_eng5" value="UPDATE_EMPLOYEE"  id="column_info_eng5" /></td>
        </tr>
        <tr id="my_row_6">
            <td><a style="cursor:pointer" onclick="return sil(6);" ><img  src="images/delete_list.gif" border="0"></a></td>
            <td><input type="text" id="column_name6" value="UPDATE_IP" name="column_name6"/>
                <input  type="hidden"  value="1" id="row_kontrol_6"  name="row_kontrol_6"/>
                <input type="hidden" value="1" name="control_6" id="control_6" />
            </td>
            <td>
                <select id="data_type6" name="data_type6" onchange="type_control(this.value,6);">
                    <option value="nvarchar">nvarchar</option>
                </select>
            </td>
            <td><input type="text" value="50" name="length6" id="length6"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" /></td>
            <td><input type="checkbox" checked="checked" name="is_null6" id="is_null6" value="1" /></td>
            <td>Başlangıç <input type="text" style="width:20px;" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  name="start6" id="start6" />, Artış <input type="text" name="increment6"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" id="increment6" /></td>
            <td><input type="text" name="default_value6" id="default_value6" /></td>
            <td><input type="text" name="column_info6" value="Güncelleyen IP" id="column_info6" /></td>
            <td><input type="text" name="column_info_eng6" value="UPDATE IP" id="column_info_eng6" /></td>													
        </tr>
    </tbody>
    <tfoot>
    	<tr>
        	<td colspan="9" style="text-align:right;"><input type="submit" value="Tablo Oluştur"/></td>
        </tr>
    </tfoot>
</cf_form_list>
</cf_form_box>
</form>	
<script type="text/javascript">
row_count=6; 

        
function control()
{
	if(create_table_.table_info.value == '')
	{
		alert('Açıklama alanını doldurunuz!');
	}
}


function type_control(deger,count)
{
	if(deger == 'int' || deger == 'datetime' || deger == 'bit' || deger =='date' || deger == 'ntext' || deger == 'float')
	{
		  document.getElementById('length' + count).setAttribute('readOnly','readonly');
		//    document.getElementById('length' + count).disabled=true;
			document.getElementById('length'+ count).value="";
	} 
	
	else
	{
		document.getElementById('length'+ count).removeAttribute("readOnly"); 
	}
	
	if (deger== 'nvarchar' || deger == 'datetime' || deger == 'bit' || deger =='date' || deger == 'ntext' || deger == 'float')
	{
		//document.getElementById('start' + count).disabled=true;
		//document.getElementById('increment' + count).disabled=true;
		 document.getElementById('start' + count).setAttribute('readOnly','readonly');
		 document.getElementById('increment' + count).setAttribute('readOnly','readonly');
		document.getElementById('start' + count).value="";
		document.getElementById('increment' + count).value="";    
	}
	else
	{
	
	document.getElementById('start'+ count).removeAttribute("readOnly");
	document.getElementById('increment'+ count).removeAttribute("readOnly");
	
	//document.getElementById('start'+count).disabled=false;
	//document.getElementById('increment'+count).disabled=false;
	}	

}

function add_row()
{
	row_count++; 
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);	
		newRow.setAttribute("name","my_row_" + row_count);
		newRow.setAttribute("id","my_row_" + row_count);		
		newRow.setAttribute("NAME","my_row_" + row_count);
		newRow.setAttribute("ID","my_row_" + row_count);		
		
		document.getElementById("record_num").value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="return sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" value="" name="column_name' + row_count + '" id="column_name' + row_count + '" />';
		newCell.innerHTML += '<input type="hidden" value="" name="row_kontrol_' + row_count +'" id="row_kontrol_' + row_count +'">';
		newCell.innerHTML += '<input type="hidden" value="1" name="control_'+ row_count +'" id="control_' + row_count +'"/>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="data_type' + row_count + '" id="data_type' + row_count + '"   onchange="type_control(this.value,'+ row_count +');"><option value="nvarchar">nvarchar</option><option value="int">int</option><option value="float">float</option><option value="datetime">datetime</option><option value="date">date</option><option value="decimal">decimal</option><option value="bit">bit</option><option value="ntext">ntext</option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" value=""  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" name="length' + row_count+'" id="length' + row_count+'" />';
	
	    newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" value="" checked="checked" name="is_null' + row_count+'" id="is_null' + row_count+'" />';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = 'Başlangıç<input type="text" value=""  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)" readonly="readonly"  style="width:20px;" name="start' + row_count+'" id="start' + row_count+'" />,Artış<input type="text" value="" readonly="readonly"  onkeypress="return SadeceRakam(event);" onblur="SadeceRakam(event,false)"  style="width:20px;" name="increment' + row_count+'" id="increment' + row_count+'" />';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" value="" name="default_value' + row_count+'" id="default_value' + row_count+'" />';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text"  value="" name="column_info' + row_count+'" id="column_info' + row_count+'" />';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text"  value="" name="column_info_eng' + row_count+'" id="column_info_eng' + row_count+'" />';
}

function sil(sy)
	{
	
		var my_element = document.getElementById('row_kontrol_'+ sy);
		var my_element=eval(document.getElementById('my_row_'+sy));
		my_element.style.display="none";
		document.getElementById('control_'+sy).value = 0;	
	}
function form_control()
	{
			var d_source = document.getElementById("database_name").value;
			var ext_params_ = document.getElementById("table_name_").value + ';' + d_source;
			var table_control = wrk_safe_query('table_control_','dsn',0,ext_params_);
			if(table_control.recordcount > 0)
			{
				alert('Tablo adı mevcut!');
				return false;
			}
			
			
			if (document.getElementById("column_name0").value== '')
			{
				alert("Identity Alana İsim Veriniz");
				return false;
			}
			
			var d_source = document.getElementById("database_name").value;
	        var ext_params_ = document.getElementById("table_name_").value + ';' + d_source;
			var table_control = wrk_safe_query('table_control_','dsn',0,ext_params_);
			if(table_control.recordcount > 0)
			{
			alert('Tablo adı mevcut!');
			return false;
			}
	  
			var row_count=document.getElementById('record_num').value;
	
			for(i=0;i<=row_count;i++)
			{	
				var control_1=document.getElementById('control_'+i).value;
				if(control_1==1)
				{
					for(j=i+1;j<=row_count;j++)
					{
						var control_=document.getElementById('control_'+j).value;
						if(document.getElementById('column_name'+i).value==document.getElementById('column_name'+j).value && control_==1)
						
						{
						alert('Kolon İsmi Mevcut');
						return false;
						}
					}
				}
			}
			
			var table_name_ = document.getElementById("table_name_").value;
			var table_info = document.getElementById("table_info").value;
			var chk=0;
			
			if (table_name_=="")
			{
				alert("tablo adı boş geçilemez");
				return false;
			}
			if(table_info == "")
			{
				alert("tablo açıklması boş geçilemez");
				return false;
			}
	var row_count=document.getElementById('record_num').value;
		for( i = 0;i<= row_count;i++)
		{
			var control_=document.getElementById('control_'+i).value;
			var column_name=document.getElementById('column_name'+ i).value;
			var column_info = document.getElementById('column_info'+ i).value;
			var data_type = document.getElementById('data_type'+ i).value;
			var length = document.getElementById('length'+ i).value;
			var is_null = !document.getElementById('is_null'+ i).checked;
			var start = document.getElementById('start'+ i).value;
			var increment = document.getElementById('increment'+ i).value;
			var default_value = document.getElementById('default_value'+ i).value;
		if(control_==1)	
		{	
			if(start!="")
			{
				chk=chk+1;
				if(chk>1)
				{
					alert("bir alana identity özellik verilebilir");
					return false;
				}
			}
			if(column_name=="")
			{
			alert("kolon adı boş geçilemez");
			return false;
			}
			
			if(column_info=="")
			{
				alert("colon açıklması boş geçilemez");
				return false;
			}

			if (document.getElementById('is_null'+ i).checked)
			{
						if (start!="")
						{
							alert("boşbırakılabilsin alanı ve otomotik arttır aynı anda tanımlanamaz");
							return false;
						}
			}
//			if (!document.getElementById('is_null'+ i).checked)
//			{			
//						if(default_value!="")
//						{
//							alert("boş bırakılabilir mi ve varsayılan deger aynı anda tanımlanamaz");
//							return false;
//						}
//			}
			if(default_value != "" && start !="")
			{
			alert("varsayılan deger ve otomotik arttır aynı anda tanımlanamaz");
			return false;
			}
			if(start=="" && increment!="")
			{
				alert("baslangic degeri giriniz");
				return false;
			}
			if(increment=="" && start!="")
			{
				alert("artış degeri giriniz");
				return false;
			}
			
		}
	 	}
     
	}	
	
	
  function SadeceRakam(e, allowedchars){
	var key = e.charCode == undefined ? e.keyCode : e.charCode;
	if ( (/^[0-9]+$/.test(String.fromCharCode(key))) || key==0 || key==13 || isPassKey(key,allowedchars) ){ return true;}
	else { return false;}
}
function isPassKey(key,allowedchars){
	if (allowedchars != null) {
		for (var i = 0; i < allowedchars.length; i++) {
			if (allowedchars[i]  == String.fromCharCode(key))			 
				return true;
		}
	}
	return false;
}
function SadeceRakamBlur(e,clear){
	var nesne = e.target ? e.target : e.srcElement;
	var val = nesne.value;
	val = val.replace(/^\s+|\s+$/g, "");
	if (clear)val = val.replace(/\s{2,}/g, " ");
	nesne.value = val;
}
	
</script>

