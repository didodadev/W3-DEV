dateformat_style = 'dd/mm/yyyy';
var DATE_INFO = 
	{
	20201212 : { klass: "highlight2", tooltip: " Bugün "}
	};
	
	function getDateInfo(date, wantsClassName) 
	{
	  var as_number = Calendar.dateToInt(date);
	  return DATE_INFO[as_number];
	}
	
	Calendar.LANG("en", "English",
		 {
			fdow: 1,                // first day of week for this locale; 0 = Sunday, 1 = Monday, etc.
			goToday: " Bugüne Git ",
			today: " Bugün ",         // appears in bottom bar
			wk: " Hf ",
			weekend: "0,6",         // 0 = Sunday, 1 = Monday, etc.
			AM: "am",
			PM: "pm",
			mn : [ " Ocak ",
				   " Şubat ",
				   " Mart ",
				   " Nisan ",
				   " Mayıs ",
				   " Haziran ",
				   " Temmuz ",
				   " Ağustos ",
				   " Eylül ",
				   " Ekim ",
				   " Kasım ",
				   " Aralık " ],
	
			smn : [ " Oca ",
					" Şub ",
					" Mar ",
					" Nis ",
					" May ",
					" Haz ",
					" Tem ",
					" Ağu ",
					" Eyl ",
					" Eki ",
					" Kas ",
					" Ara " ],
	
			dn : [ " Pazar ",
				   " Pazartesi ",
				   " Salı ",
				   " Çarşamba ",
				   " Perşembe ",
				   " Cuma ",
				   " Cumartesi ",
				   " Pazar " ],
	
			sdn : [ " Pz "," Pt "," Sl "," Çr "," Pr "," Cu "," Ct "," Pz " ]
	});

	/**
	 * Sepete ürün ekleme
	 * @param {integer} stock_id stok_id
	 * @param {integer} quantity miktar
	 * @param {integer} widget_id widget_id
	 */
	function add_product(stock_id, quantity, widget_id){

		var data = new FormData();
		data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
		data.append('method', 'add_product_to_basket');
		data.append('form_data', JSON.stringify({
			stock_id: stock_id,
			quantity: quantity,
			widget_id: widget_id
		}));
		AjaxControlPostDataJson('/datagate',data,function(response) {
		
		if( response.STATUS ){
			toastr.success(response.MESSAGE, {timeOut: 4000, progressBar : true, closeButton : true});
			var elem = $("li[type=cart] > a > i > span"), 
				oldCount = parseInt( elem.text() );

			elem.text( oldCount + parseInt( quantity ) );
		}
		else toastr.error(response.MESSAGE, {timeOut: 5000, progressBar : true, closeButton : true});
	});

}
	/**
	 * Sepetteki ürünü silme
	 * @param {integer} product_id 
	 * @param {integer} stock_id 
	 * @param {integer|null} partner_id 
	 * @param {integer|null} consumer_id 
	 */
	function del_product(product_id, stock_id, partner_id, consumer_id){
		var data = new FormData();
		data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
		data.append('method', 'del_product_from_basket');
		data.append('form_data', JSON.stringify({
			product_id : product_id,
			stock_id : stock_id,
			partner_id : partner_id,
			consumer_id : consumer_id
		}));
		AjaxControlPostDataJson('/datagate',data,function(response) {
			if( response.STATUS ){
				toastr.success(response.MESSAGE, {timeOut: 4000, progressBar : true, closeButton : true});
				location.reload();
			}else toastr.error(response.MESSAGE, {timeOut: 5000, progressBar : true, closeButton : true});
		});

	}

	/**
	 * Sepet üzerinden sipariş oluşturma
	 * @param {integer|null} partner_id 
	 * @param {integer|null} consumer_id 
	 * @param {integer|null} subscription_id 
	 */
	function add_order(partner_id, consumer_id, subscription_id = ''){
		var data = new FormData();
		data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
		data.append('method', 'show_product_on_basket');
		data.append('form_data', JSON.stringify({
			partner_id : partner_id,
			consumer_id : consumer_id
		}));

		AjaxControlPostDataJson('/datagate',data,function(response) { 
			if( response.SEPET_ADET > 0){

				var data2 = new FormData();
				data2.append('cfc', '/V16/objects2/sale/cfc/basketAction');
				data2.append('method', 'add_order_func');
				data2.append('form_data', JSON.stringify({
					partner_id : partner_id,
					consumer_id : consumer_id,
					subscription_id: subscription_id
				}));

				AjaxControlPostDataJson('/datagate',data2,function(response) { 
					if( response.STATUS ){
						toastr.success(response.MESSAGE, {timeOut: 4000, progressBar : true, closeButton : true});
						location.href = "/welcome";
					}else toastr.error(response.MESSAGE, {timeOut: 5000, progressBar : true, closeButton : true});
				});
			}else{
				toastr.error("Sepetinizde Ürün Bulunmuyor", {timeOut: 5000, progressBar : true, closeButton : true});
			}
		});

	}

	/**
	 * Sepet üzerinden teklif oluşturma
	 * @param {integer|null} partner_id 
	 * @param {integer|null} consumer_id 
	 */
	function add_offer(partner_id, consumer_id) {
		var data = new FormData();
		data.append('cfc', '/V16/objects2/sale/cfc/basketAction');
		data.append('method', 'add_offer_func');
		data.append('form_data', JSON.stringify({
			partner_id : partner_id,
			consumer_id : consumer_id
		}));

		AjaxControlPostDataJson('/datagate',data,function(response) { 
			if( response.STATUS ){
				toastr.success(response.MESSAGE, {timeOut: 4000, progressBar : true, closeButton : true});
				location.href = "/welcome";
			}else toastr.error(response.MESSAGE, {timeOut: 5000, progressBar : true, closeButton : true});
		});

	}

/* Popupları draggable box olarak açılması için openBoxDraggable ve LoadPopupBox fonksiyonları oluşturuldu! E.Y*/
function openBoxDraggable(url, modal_id = "", size = ""){
	var uniqueId = modal_id == '' ? Math.floor(Math.random() * 999999999999999) : modal_id;
	if($('#popup_box_' + uniqueId + '').length == 0){ $('<div>').addClass("ui-draggable-box" + " " + size).attr({"id" : "popup_box_" + uniqueId + ""}).appendTo($('body')); }
	$('#popup_box_' + uniqueId + '').css({'display' : 'block', 'visibility' : 'visible'});
	url += !url.includes('&modal_id=') ? "&draggable=1&modal_id=" + uniqueId + "" : "&draggable=1";
	AjaxPageLoad(url, "popup_box_" + uniqueId + "");
	return false;
}
function closeBoxDraggable( modal_id = "", box_id = "" ){
	$('#popup_box_' + modal_id + '').remove();
	if( box_id != '' ){
		if( $("#"+ box_id +" i.catalyst-refresh").length >0 ) $("#"+ box_id +" i.catalyst-refresh").parent('a').click();
		else if ( $("#"+ box_id +" span.catalyst-refresh").length >0 ) $("#"+ box_id +" span.catalyst-refresh").click();
		else if ( $("#"+ box_id +" a#wrk_search_button").length >0 ) $("#"+ box_id +" a#wrk_search_button").click();
	}
}
function loadPopupBox(form_name, modal_id = ""){
	var form = $('form[name = ' + form_name + ']');
	openBoxDraggable( decodeURIComponent( form.attr( "action" ) + '&' + form.serialize() ).replaceAll("+", " "), modal_id );
	return false;
}
function alertMessage(options) {
	Swal.fire({
		title: options.title,
		text: options.message,
		type: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#1fbb39',
		cancelButtonColor: '#3085d6',
		confirmButtonText: 'Tamam',
		cancelButtonText: 'İptal',
		closeOnConfirm: true,
		allowOutsideClick:false
	}).then((result) => {
		if( options.confirmFunction != undefined && typeof options.confirmFunction == 'function' ) options.confirmFunction(result);
	});
}

$(document).ready(function() {
	$('select.select2').each(function () { $(this).select2(); });

	$('input[data-payment = card_number]').each(function () { Payment.formatCardNumber( $(this) ) });
	$('input[data-payment = card_expired_date]').each(function () { Payment.formatCardExpiry( $(this) ) });
	$('input[data-payment = card_cvc]').each(function () { Payment.formatCardCVC( $(this) ) });
	
	var phoneMaskOptions = { mask: '(000) 000 0000' };
	$('input[data-number_format = phone]').each(function () { IMask(this, phoneMaskOptions); });
});