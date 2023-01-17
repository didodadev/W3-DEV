<style>
body{background-color:#eef1f5;}

.cargo_table thead tr th{font-weight:bold; color:#000000; font-size:16px;padding:5px;border-right:1px solid #cccccc;border-bottom:1px solid #cccccc; height:25px;}
.cargo_table tbody tr td{color:#000000; font-size:14px;padding:5px;border-right:1px solid #cccccc;border-bottom:1px solid #cccccc; height:25px;}
.cargo_table {width:100%; font-size:12px;}

.noborder{border-right:0px solid #cccccc !important;}

.green{color:green;}
.red{color:red;}

.list_page_header{font-size:20px; font-weight:bold;}

input:focus ~ .floating-label,
input:not(:focus):valid ~ .floating-label{
  top: 8px;
  bottom: 10px;
  left: 20px;
  font-size: 11px;
  opacity: 1;
}

.floating-label {
  position: absolute;
  pointer-events: none;
  left: 20px;
  top: 10px;
  transition: 0.2s ease all;
}

.cargo_input {
  font-size: 14px;
  width:200px;
  height:30px !important;
}

.white_div{background-color:#ffffff; padding:20px; margin:20px;}

.cargo_div_right{width:100%; text-align:right;}

.cargo_button{
	background-color:#ffffff !important; 
	font-size:15px !important; 
	color:#000000 !important; 
	border:2px solid #cccccc !important;
	padding:5px !important;
	min-width:125px !important;
	min-height:45px !important;
	border-radius: 10px !important;
	}

.cargo_link
{
	color:#01b1f3 !important;
}
	
a.cargo_link :link
{
	color:#01b1f3 !important;
}

a.cargo_link :visited 
{
	color:#01b1f3 !important;
}

.icon-print{font-size:30px;}
.icon-settings{font-size:30px;}
</style>

<cfparam name="attributes.ozel_kod2" default="DRIVER">
<cfparam name="attributes.list_page_header" default="Drivers">
<cfparam name="attributes.list_page_id_header" default="DRIVER ID">


<span class="list_page_header"><cfoutput>#attributes.list_page_header#</cfoutput><br><br></span>
<div class="white_div">
	<cfinclude template="employee_list.cfm">
</div>		