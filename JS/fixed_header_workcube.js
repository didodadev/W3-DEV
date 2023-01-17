//Bu dosyayı kullanabilmek için jquery_1_5.js dosyasının ilgili JS klasörünün altında olması gerekmektedir
//Bu script ekranda başlıkların yada istenen sütunların kaymaması için eklenmiştir.
//Kullanımı
//	<table>
//		<tr>
//			<td><div id="divHeader" style="overflow:hidden;width:784px;">Başlık kısmı içerisine table kullanabilirsiniz</div></td>
//		</tr>
//		<tr>
//  		 <td><div id="firstcol" style="overflow: hidden;height:284px">Burası hareket etmeyen ilk sütun. İsterseniz bu kısmı kullanmayabilirsiniz.</div></td>
//	 		<td><div id="table_div" style="overflow: auto;width:800px;height:300px;position:relative;" onscroll="fnScroll()" >Burası verileri yazdığımız yer</div></td>
//		</tr>
//	</table>
//Örnek: test\Emin\bos4.cfm dosyasında uygulamalı örneği vardır.

$(document).ready(function(){
fnAdjustTable();
});

fnAdjustTable=function(){

var colCount=$('#firstTr>td').length; //get total number of column

var m=0;
var n=0;
var brow='mozilla';
jQuery.each(jQuery.browser, function(i, val) {
if(val==true){

brow=i.toString();
}
});
$('.tableHeader').each(function(i){
if(m<colCount){

if(brow=='mozilla'){
$('#firstTd').css("width",$('.tableFirstCol').innerWidth());//for adjusting first td

$(this).css('width',$('#table_div td:eq('+m+')').innerWidth());//for assigning width to table Header div
}
else if(brow=='msie'){
$('#firstTd').css("width",$('.tableFirstCol').width());

$(this).css('width',$('#table_div td:eq('+m+')').width()-2);//In IE there is difference of 2 px
}
else if(brow=='safari'){
$('#firstTd').css("width",$('.tableFirstCol').width());

$(this).css('width',$('#table_div td:eq('+m+')').width());
}
else{
$('#firstTd').css("width",$('.tableFirstCol').width());

$(this).css('width',$('#table_div td:eq('+m+')').innerWidth());
}
}
m++;
});

$('.tableFirstCol').each(function(i){
if(brow=='mozilla'){
$(this).css('height',$('#table_div td:eq('+colCount*n+')').outerHeight());//for providing height using scrollable table column height
}else if(brow=='msie'){

$(this).css('height',$('#table_div td:eq('+colCount*n+')').innerHeight()-2);
}else{
$(this).css('height',$('#table_div td:eq('+colCount*n+')').height());
}
n++;
});

}

//function to support scrolling of title and first column
fnScroll=function(){
	$('#divHeader').scrollLeft($('#table_div').scrollLeft());
	$('#firstcol').scrollTop($('#table_div').scrollTop());
}