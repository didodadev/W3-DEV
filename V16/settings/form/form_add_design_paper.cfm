<table cellpadding="0" cellspacing="0" align="center" width="98%" height="35" >
	<tr>
		<td height="35" class="headbold">Şablon Tasarımları</td>
	</tr>
</table>
<table id="main_table" cellspacing="1" cellpadding="2" style="width:210mm;height:350mm;" align="left" border="0">
	<cfform name="FormDesignPaper" action="#request.self#?fuseaction=settings.design_paper" method="post">
        <input type="hidden" name="IsSubmit" id="IsSubmit" value="1">
		<tr valign="top">
			<td>
			<!--- Listesi --->
			<table class="color-header" cellpadding="2" cellspacing="1" style="width:80mm;" border="0" >
				<!--- Sayfa Ozellikleri --->
				<tr valign="top" id="_page_properties_" class="color-row">
					<td height="100" colspan="2">
					<table border="0" style="position:absolute;z-index:88;overflow:auto;">
						<tr>
							<td width="60">Adı *</td>
							<td colspan="3"><input type="text" name="PrintDesignName" id="PrintDesignName" value="" style="width:45mm;"></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no ='657.Sayfa Tipi'> *</td>
							<td colspan="3">
								<select name="PrintDesignType" id="PrintDesignType" style="width:45mm;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<option value="10-20"><cf_get_lang_main no ='29.Fatura'></option>
									<option value="30-13"><cf_get_lang_main no ='361.İrsaliye'></option>
									<option value="31-13"><cf_get_lang no ='208.Stok Fişi'></option>
									<option value="70-11"><cf_get_lang no ='209.Satış Teklifi'></option>
									<option value="73-11"><cf_get_lang no ='230.Satış Siparişi'></option>
									<option value="90-12"><cf_get_lang no ='231.Satınalma Teklifi'></option>
									<option value="91-12"><cf_get_lang no ='235.Satınalma Siparişi'></option>
								</select>
							</td>
						</tr>
						 <tr>
							<td><cf_get_lang_main no ='283.Genişlik'></td>
							<td><input type="text" name="PageWidth" id="PageWidth" value="210" onChange="page_style(this.value,'width');" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
							<td width="45"><cf_get_lang_main no ='284.Yükseklik'></td>
							<td><input type="text" name="PageHeight" id="PageHeight" value="297" onChange="page_style(this.value,'height');" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
						</tr>
						<tr>
						<td></td>
						<td colspan="2" align="left"><cf_workcube_buttons is_cancel='1' is_delete='0' insert_alert='' add_function='submit_control()'></td></tr>				
					</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
	</cfform>
</table>        	

<!--- Sürükle Bırak --->
<script type="text/javascript">
function submit_control()
{
	if(document.getElementById('PrintDesignName').value == "")
	{
		alert("Sayfa Adı Girmelisiniz !");
		return false;
	}
	if(document.getElementById('PrintDesignType').value == "")
	{
		alert("Sayfa Tipi Seçmelisiniz!");
		return false;
	}
}

function page_style(_value_,property){
	if(property == 'width'){
		document.getElementById('main_div').style.width = _value_+'mm';
		document.getElementById('main_table').style.width = _value_+'mm';
	}	
	else if(property == 'height'){
		document.getElementById('main_div').style.height =  _value_+'mm';
		document.getElementById('main_table').style.height =parseInt(3+parseInt(_value_))+'mm';
	}	
}
//inputlardaki degisikliklerin divlere yansimasi islemi, tip gonderilerek tek yerden kontrol saglandi
function design_div_position(obj,type,row_count,input,part)
{
	if(row_count == 'all_TopMargin' || row_count == 'all_Height')
	{
		var little_length = document.getElementsByName('middle_objs').length;
		for(lind=0;lind<little_length;lind++){
			var xlind =lind+1; 
			var input = list_getat(document.getElementsByName('middle_objs')[lind].name,2,'_');
			if(document.getElementsByName('middle_objs')[lind].checked == true){
				if(row_count == 'all_Height')
					document.getElementById('div_y_'+input+'_Check_'+xlind).style.height = obj.value+'mm';
				if(row_count == 'all_TopMargin'){
					document.getElementById('div_y_'+input+'_Check_'+xlind).style.top = obj.value+'mm';
					document.getElementById('div_y_'+input+'_Check_'+xlind).onmousedown= function () {Drag.init(document.getElementById('y_'+input+'_Check_'+xlind), null, 15, 180,filterNum(obj.value),filterNum(obj.value))}
					Drag.init(document.getElementById('div_y_'+input+'_Check_'+xlind), null, 15, 180, filterNum(obj.value),filterNum(obj.value));
				}	
			}	
		}
	}
	else
	{
		if(document.getElementById('div_'+input+'_Check_'+row_count))
		{
			if(type=='width')
				document.getElementById('div_'+input+'_Check_'+row_count).style.width = obj.value+'mm';
			if(type=='height')
				document.getElementById('div_'+input+'_Check_'+row_count).style.height = obj.value+'mm';
			if(type=='top')
				document.getElementById('div_'+input+'_Check_'+row_count).style.top = obj.value+'mm';
			if(type=='left')
				document.getElementById('div_'+input+'_Check_'+row_count).style.left = obj.value+'mm';
		}	
	}	
}

var Drag = {

	obj : null,
	init : function(o, oRoot, minX, maxX, minY, maxY, bSwapHorzRef, bSwapVertRef, fXMapper, fYMapper)
	{
		o.onmousedown	= Drag.start;
		o.hmode			= bSwapHorzRef ? false : true ;
		o.vmode			= bSwapVertRef ? false : true ;

		o.root = oRoot && oRoot != null ? oRoot : o ;

		if (o.hmode  && isNaN(parseInt(o.root.style.left  ))) o.root.style.left   = "0mm";
		if (o.vmode  && isNaN(parseInt(o.root.style.top   ))) o.root.style.top    = "0mm";
		if (!o.hmode && isNaN(parseInt(o.root.style.right ))) o.root.style.right  = "0mm";
		if (!o.vmode && isNaN(parseInt(o.root.style.bottom))) o.root.style.bottom = "0mm";

		o.minX	= typeof minX != 'undefined' ? minX : null;
		o.minY	= typeof minY != 'undefined' ? minY : null;
		o.maxX	= typeof maxX != 'undefined' ? maxX : null;
		o.maxY	= typeof maxY != 'undefined' ? maxY : null;

		o.xMapper = fXMapper ? fXMapper : null;
		o.yMapper = fYMapper ? fYMapper : null;

		o.root.onDragStart	= new Function();
		o.root.onDragEnd	= new Function();
		o.root.onDrag		= new Function();
	},

	start : function(e)
	{
		var o = Drag.obj = this;
		e = Drag.fixE(e);
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		o.root.onDragStart(x, y);

		o.lastMouseX	= e.clientX;
		o.lastMouseY	= e.clientY;

		if (o.hmode) {
			if (o.minX != null)	o.minMouseX	= e.clientX - x + o.minX;
			if (o.maxX != null)	o.maxMouseX	= o.minMouseX + o.maxX - o.minX;
		} else {
			if (o.minX != null) o.maxMouseX = -o.minX + e.clientX + x;
			if (o.maxX != null) o.minMouseX = -o.maxX + e.clientX + x;
		}

		if (o.vmode) {
			if (o.minY != null)	o.minMouseY	= e.clientY - y + o.minY;
			if (o.maxY != null)	o.maxMouseY	= o.minMouseY + o.maxY - o.minY;
		} else {
			if (o.minY != null) o.maxMouseY = -o.minY + e.clientY + y;
			if (o.maxY != null) o.minMouseY = -o.maxY + e.clientY + y;
		}

		document.onmousemove	= Drag.drag;
		document.onmouseup		= Drag.end;

		return false;
	},

	drag : function(e)
	{
		e = Drag.fixE(e);
		var o = Drag.obj;

		var ey	= e.clientY;
		var ex	= e.clientX;
		var y = parseInt(o.vmode ? o.root.style.top  : o.root.style.bottom);
		var x = parseInt(o.hmode ? o.root.style.left : o.root.style.right );
		var nx, ny;

		if (o.minX != null) ex = o.hmode ? Math.max(ex, o.minMouseX) : Math.min(ex, o.maxMouseX);
		if (o.maxX != null) ex = o.hmode ? Math.min(ex, o.maxMouseX) : Math.max(ex, o.minMouseX);
		if (o.minY != null) ey = o.vmode ? Math.max(ey, o.minMouseY) : Math.min(ey, o.maxMouseY);
		if (o.maxY != null) ey = o.vmode ? Math.min(ey, o.maxMouseY) : Math.max(ey, o.minMouseY);

		nx = x + ((ex - o.lastMouseX) * (o.hmode ? 1 : -1));
		ny = y + ((ey - o.lastMouseY) * (o.vmode ? 1 : -1));

		if (o.xMapper)		nx = o.xMapper(y)
		else if (o.yMapper)	ny = o.yMapper(x)

		Drag.obj.root.style[o.hmode ? "left" : "right"] = nx + "mm";
		Drag.obj.root.style[o.vmode ? "top" : "bottom"] = ny + "mm";
		Drag.obj.lastMouseX	= ex;
		Drag.obj.lastMouseY	= ey;

		Drag.obj.root.onDrag(nx, ny);
		return false;
	},

	end : function()
	{
		check_obj_number = list_getat(Drag.obj.id,list_len(Drag.obj.id,'_'),'_');
		check_obj_part = Drag.obj.id.substr(4,1);
		var ayrac_number = (check_obj_number<10)?12:13;
		check_obj_input = Drag.obj.id.substr(4,(Drag.obj.id.length-parseInt(ayrac_number)));
		document.getElementById(check_obj_input+'_Width_'+check_obj_number).value = filterNum(Drag.obj.style.width);
		document.getElementById(check_obj_input+'_LeftMargin_'+check_obj_number).value = filterNum(Drag.obj.style.left);
		if(check_obj_part != 'y')
		{
			document.getElementById(check_obj_input+'_Height_'+check_obj_number).value = filterNum(Drag.obj.style.height);
			document.getElementById(check_obj_input+'_TopMargin_'+check_obj_number).value = filterNum(Drag.obj.style.top);
		}
		document.onmousemove = null;
		document.onmouseup   = null;
		Drag.obj.root.onDragEnd(	parseInt(Drag.obj.root.style[Drag.obj.hmode ? "left" : "right"]), 
									parseInt(Drag.obj.root.style[Drag.obj.vmode ? "top" : "bottom"]));
		Drag.obj = null;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};
</script>
<!--- //Sürükle Bırak --->
<script type="text/javascript">
	var selected_div ='';
	var selected_tr ='';
	var sayac = 0;
	function div_control(){//yön tuşlarını kullanarak seçilen divi haraket ettirmek için yapıldı...
		//event.keyCode : 40 aşağı,39 sağ,37 sol,38 yukarı anlamına geliyor...
		if(selected_div != ""){//seçili olan bir div var ise..
			var part = list_getat(selected_div,2,'_');//x,y,z mi?
			var field_name = list_getat(selected_div,3,'_');
			var field_number = list_getat(selected_div,5,'_');
			var input_left = part+'_'+field_name+'_LeftMargin_'+field_number;
			var input_top = part+'_'+field_name+'_TopMargin_'+field_number;
			if(event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40)
				document.getElementById(input_left).focus();
				if(event.keyCode == 37){ //sol tusa basılıyorsa...
					document.getElementById(selected_div).style.left = filterNum(document.getElementById(selected_div).style.left)-1+'mm';
					document.getElementById(input_left).value = filterNum(document.getElementById(selected_div).style.left)-1;
				}	
				else if(event.keyCode == 39){//sağ tusa basılıyorsa...
					document.getElementById(selected_div).style.left = filterNum(document.getElementById(selected_div).style.left)+1+'mm';
					document.getElementById(input_left).value = filterNum(document.getElementById(selected_div).style.left)+1;
				}	
				else if(event.keyCode == 40 && part != 'y'){ //asağı tusuna basılıyorsa...
					document.getElementById(selected_div).style.top = filterNum(document.getElementById(selected_div).style.top)+1+'mm';
					document.getElementById(input_top).value = filterNum(document.getElementById(selected_div).style.top)+1;
			}	
			else if(event.keyCode == 38 && part != 'y'){ //yukarı tusuna basılıyorsa...
				document.getElementById(selected_div).style.top = filterNum(document.getElementById(selected_div).style.top)-1+'mm';
				document.getElementById(input_top).value = filterNum(document.getElementById(selected_div).style.top)-1;
			}	
			return false;	
		}
	}
	document.body.onkeydown = function () { div_control(); }
	function select_div_border(div_id){
		var part = list_getat(div_id,2,'_');
		var tr_id = list_getat(div_id,3,'_');
		if(selected_div != ""){
			document.getElementById(selected_tr).style.backgroundColor ='';
			document.getElementById(selected_div).style.border = '1px solid black';
		}
		document.getElementById(part+'_'+tr_id).style.backgroundColor ='FF9933';	
		document.getElementById(div_id).style.border = '1px solid red';
		selected_div = div_id;
		selected_tr = part+'_'+tr_id;
	}
	function add_to_appendchild(checked_status,width,height,top,left,name,part)
	{
		if(checked_status.checked==true)
		{
			sayac++;
			var newdiv = document.createElement('div'); // yeni bir div olusturuluyor
			//newdiv.ondblclick = function () { show_main_source_code(this.id) }
			div_name= 'div_'+checked_status.name;
			newdiv.setAttribute('id',div_name);
			newdiv.style.position = 'absolute';
			if(part == 'x') // divin icinin renklendirilmesi
				newdiv.style.background = 'BFECFF';
			else if(part == 'y')
				newdiv.style.background = 'FF6600';
			else
				newdiv.style.background = '33CC33';
			newdiv.style.zIndex=999;
			newdiv.style.width = width; //div genisligi
			newdiv.style.height = height; //div yuksekligi
			newdiv.style.left = left; //div sol margin
			newdiv.style.top = top; //div ust margin
			newdiv.style.border = '1px solid black'; 
			newdiv.innerHTML= name;
			document.getElementById('main_div').appendChild(newdiv);
			newdiv.onclick = function () { select_div_border(newdiv.id) }
			if(part == 'x')
			{
				newdiv.onmousedown= function () {Drag.init(document.getElementById(div_name), null, 5, 180, 5, 600)}
				Drag.init(document.getElementById(div_name), null, 5, 180, 5, 600);
			}	
			else if(part == 'y')
			{
				newdiv.onmousedown= function () {Drag.init(document.getElementById(div_name), null, 15, filterNum(document.all.ColumnWidth.value), filterNum(top),filterNum(top))}
				Drag.init(document.getElementById(div_name), null, 5, filterNum(document.all.ColumnWidth.value), filterNum(top),filterNum(top));
			}
			else if(part == 'z')
			{
				newdiv.onmousedown= function () {Drag.init(document.getElementById(div_name), null, 5, 180, 200, 600)}
				Drag.init(document.getElementById(div_name), null, 5, 180, 200, 600);
			}
		}
		else
		{
			document.getElementById('main_div').removeChild(document.getElementById('div_'+checked_status.name)); 
		}
		return;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
