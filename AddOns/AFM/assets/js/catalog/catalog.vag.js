$(document).ready(function() {
	
	/////////////////////////
	// Subgroup Units Page //
	/////////////////////////
	
	// Sidemenu
	if ($('#sg-units').length) {
		$('.vag-unit').click(function(ev){
			ev.preventDefault();
			var href = $(ev.target).closest('.vag-unit').find('.unit-title a').attr('href');
			if (href) {
				window.location.href = href;
			}
		});		
	}	
	
	
	///////////////
	// Unit Page //
	///////////////
	
	if ($('#unit-dwg').length) 
	{				
		setupContainers();
		
		// Part Info 
		$('#part-info').on('show.bs.modal', function (ev) {
		    
            /////////////////////////Get PartDetailInfo///////////////////////////////////////
		    var modal = $(this);
		    var mBody = $('#part-info .modal-body');
		    var btn = $(ev.relatedTarget);
		    var partRow = btn.closest('tr.part');
		    var partInfoStore = btn.parent('td').find('.part-info-store');
		    var partNo = partRow.data('part-no');
		    var prmPartNo = partNo.toString();
		    if (partNo.toString().indexOf(" ") >= 0) {
		        var re = / /g;
		        var r = partNo.replace(re, "");
		        prmPartNo = r;
		        partNo = r;
		    }


		    var partNoFmt = partRow.find('td.partno').text();
		    var prmMake = $('#makeCode_FindParts').attr("value");
		    var prmMarket = $("#catalogMarket_FindParts").attr("value");
		    var prmModel = $("#catalogModel_FindParts").attr("value");
		    var prmEpisType = $("#episType_FindParts").attr("value");

		    var ParamForPartDetail = {
		        make: prmMake,
		        market: prmMarket,
		        part_no: prmPartNo,
		    };
		    $.ajax({
		        type: "POST",
		        url: "/Catalog/GetPartDetailInfo",
		        data: JSON.stringify(ParamForPartDetail),
		        contentType: 'application/json',
		        beforeSend: function () {
		            $("#overlay").show();
		        },
		        success: function (msg) {
		            $("#part-detail-info").html(msg);
		        },
		        error: function (msg) {
		            alert(msg);
		        },
		        complete: function () {
		            	
		            /////////////////////////////////////////////////////////////////////////////////

		            var modal = $(this);
		            var mBody = $('#part-info .modal-body');
		            var btn = $(ev.relatedTarget);
		            var partRow = btn.closest('tr.part');
		            var partInfoStore = btn.parent('td').find('.part-info-store');
		            var partNo = partRow.data('part-no');
		            var partNoFmt = partRow.find('td.partno').text();

		            $('#part-number').html(partNoFmt);

		            mBody.find('> div > ul.nav > li, > div > .tab-content > .tab-pane').removeClass('active');
		            $('#general-nav-tab, #general-tab').addClass('active');

		            // Copying data from info store inside part table
		            //

		            // sys_remark
		            if (partInfoStore.find('.part-sys-remark').length) {				
		            	$('#part-sys-remark')
		            		.removeClass('hidden')
		            		.html(partInfoStore.find('.part-sys-remark').html());
		            } else {
		            	$('#part-sys-remark').addClass('hidden');
		            }			

		            // part_symbol
		            if (partInfoStore.find('.part-symbol').length) {
		            	$('#part-info-dl .part-symbol').removeClass('hidden');
		            	$('#part-symbol-desc').html(partInfoStore.find('.part-symbol').html());
		            } else {
		            	$('#part-info-dl .part-symbol').addClass('hidden');
		            }



		            // part_replaced_by
		            if ($('#part-detail-info').find('#part-replaced-by').length) {
		            	$('#part-replaced-by')
		            		.removeClass('hidden')
		            		.html(partInfoStore.find('.part-replaced-by').html());
		            } else {
		            	$('#part-replaced-by').addClass('hidden');
		            }	

		            // part_replaces
		            if ($('#part-detail-info').find('#part-replaces').length) {
		            	$('#part-replaces')
		            		.removeClass('hidden')
		            		.html(partInfoStore.find('.part-replaces').html());
		            } else {
		            	$('#part-replaces').addClass('hidden');
		            }

		            // Replacements tab visibility
		            if ($('#part-detail-info').find('#part-replaced-by').length || $('#part-detail-info').find('#part-replaces').length) {
		            	$('#replacements-nav-tab, #replacements-tab').removeClass('hidden');
		            } else {
		            	$('#replacements-nav-tab, #replacements-tab').addClass('hidden');
		            }

		            // linked_parts
		            if (partInfoStore.find('.linked-parts').length) {
		            	$('#linked-parts')
		            		.removeClass('hidden')
		            		.html(partInfoStore.find('.linked-parts').html());
		            	$('#linked-parts-nav-tab, #linked-parts-tab').removeClass('hidden');
		            } else {
		            	$('#linked-parts').addClass('hidden');
		            	$('#linked-parts-nav-tab, #linked-parts-tab').addClass('hidden');
		            }
		            // Components tab visibility
		            if ($('#part-detail-info').find('#components-part').length) {
		                $('#components-part')
		            		.removeClass('hidden');
		                $('#components-nav-tab, #components-tab').removeClass('hidden');
		            } else {
		                $('#components-nav-tab, #components-tab').addClass('hidden');
		            }
		            // Composites tab visibility
		            if ($('#part-detail-info').find('#composites-part').length) {
		                $('#composites-part')
		            		.removeClass('hidden');
		                $('#composites-nav-tab, #composites-tab').removeClass('hidden');
		            } else {
		                $('#composites-nav-tab, #composites-tab').addClass('hidden');
		            }
		            // Applications tab visibility
		            if ($('#part-detail-info').find('#applications-part').length) {
		                $('#applications-part')
		            		.removeClass('hidden');
		                $('#applications-nav-tab, #applications-tab').removeClass('hidden');
		            } else {
		                $('#applications-nav-tab, #applications-tab').addClass('hidden');
		            }

		            $("#overlay").hide();
		        }
		    });

            /////////////////////////////////////////////////////////////////////////////////

			var modal = $(this);
			var mBody = $('#part-info .modal-body');			
			var btn = $(ev.relatedTarget);
			var partRow = btn.closest('tr.part');
			var partInfoStore = btn.parent('td').find('.part-info-store');
			var partNo = partRow.data('part-no');
			var partNoFmt = partRow.find('td.partno').text();			
			
			$('#part-number').html(partNoFmt);
			
			mBody.find('> div > ul.nav > li, > div > .tab-content > .tab-pane').removeClass('active');
			$('#general-nav-tab, #general-tab').addClass('active');
			
			
			var include = 'part_name_and_group,applications';
			if (partRow.data('is-composite')) {
				include += ',components';
			}
			if (partRow.data('is-component')) {
				include += ',composites';
			}
			
			
									
		})		
		
		// Blueimp Gallery
		$('.btn-part-gallery').click(function(ev){			
			var options = {event: ev};
			var links = $(this).parent('td.btn-cell').find('div.part-gallery-photos > a');
			blueimp.Gallery(links, options);
		});
			
		// Affix
		// $('#affix-left-pane, #parts-tbl-head').affix({
		// 		offset: {
		// 			top: function() {
		// 				return (this.top = $('#unit-dwg-col').offset().top);
		// 			},
		// 			bottom: parseInt($('.content.catalog').css('padding-bottom')) + 
		// 					$('.footer-top').outerHeight(true) + 
		// 					$('.footer-bottom').outerHeight(true)
		// 		}
		// });			
		// $('#parts-tbl-head').on('affix.bs.affix', function(e) {
		// 	$('#unit-parts-tbl thead tr th').each(function(i, th){
		// 		$(th).innerWidth($(th).innerWidth());
		// 	});		
		// 	$('#unit-parts-tbl tbody tr td').each(function (i, td) {
		// 	    $(td).width($(td).width());
		// 	});

		// });
		// // Reload of page with affixed table head
		// if ($('#parts-tbl-head').hasClass('affix')) {
		// 	$('#unit-parts-tbl tbody tr.part:eq(1) td').each(function(i, td){
		// 		$('#unit-parts-tbl thead tr th:eq(' + i + ')').outerWidth($(td).outerWidth());				
		// 	});	
		// }
		
		// Panzoom setup
		var panzoom = $('#unit-dwg').panzoom({
			cursor: 'default',
			animate: true,
			minScale: 1			
		});
		panzoom.parent().on('mousewheel.focal', function(e) {
			// Mousewheel zoom on medium and large displays (should not prevent page scrolling)
			if ($(window).width() >= 992) {
				e.preventDefault();
				var delta = e.delta || e.originalEvent.wheelDelta;
				var zoomOut = delta ? delta < 0 : e.originalEvent.deltaY > 0;
				$('#unit-dwg').panzoom('zoom', zoomOut, {
					increment: 0.1,
					animate: false,
					focal: e
				});
			}
		});
		panzoom.on('panzoomzoom', function(e, panzoom, scale, opts) {
			if (scale == opts.minScale) {
				$('#zoom-out-btn').addClass('hidden');
			} else if (scale == opts.maxScale) {
				$('#zoom-in-btn').addClass('hidden');
			} else {
				$('#zoom-in-btn').removeClass('hidden');
				$('#zoom-out-btn').removeClass('hidden');
			}
			setupHotspots();
			$('#unit-dwg-container .hotspot').removeClass('hidden');
		});
		panzoom.on('panzoompan', function(e, panzoom, x, y) {
			setupHotspots();
		});		
		$('#zoom-in-btn').click(function(ev){
			ev.preventDefault();
			$('#unit-dwg-container .hotspot').addClass('hidden');
			$('#unit-dwg').panzoom('zoom');
		});
		$('#zoom-out-btn').click(function(ev){
			ev.preventDefault();
			$('#unit-dwg-container .hotspot').addClass('hidden');
			$('#unit-dwg').panzoom('zoom', true);
		});		
		
		// Part checkboxes
		$('#unit-parts-tbl tr.part input.part-checkbox').change(function(ev){
			var cb = $(this);
			var dwgPos = cb.closest('tr.part').find('td.dwg-pos').text();
			var hs = $('#unit-dwg-container .hotspot[data-hsname="' + dwgPos + '"]');
			if (hs.length) {
				if (cb.is(':checked')) {
					cb.closest('tr.part').addClass('checked');
					hs.addClass('selected');
				} else {
					cb.closest('tr.part').removeClass('checked');
					hs.removeClass('selected');
				}
			}
			
            //Show selected button
			// 'Show selected' button update
			//var btn = $('#show-selected-btn');			
			//var checkedCount = $('#unit-parts-tbl tr.part input.part-checkbox:checked').length;
			//if (checkedCount && !btn.is(':visible')) {
			//	btn.hide().removeClass('hidden').show(200);
			//}
			// btn.find('.badge').
			// 	fadeIn(200).fadeOut(200).fadeIn(600).
			// 	html(checkedCount);
			// if (!checkedCount) {
			// 	btn.hide(500);
			// }
		});
		
		// Hotspots
		$('#unit-dwg-container .hotspot').click(function(ev){
			ev.preventDefault();
			$('#unit-parts-tbl tr.part[data-dwg-pos="' + $(this).data('hsname') + '"]').find('input.part-checkbox').click();
			//alert($('#unit-parts-tbl tr.part[data-dwg-pos="' + $(this).data('hsname') + '"]').offset().top);
		    $('html, body').animate({
		        scrollTop:$('#unit-parts-tbl tr.part[data-dwg-pos="' + $(this).data('hsname') + '"]').offset().top-150
		    }, 500);
		});
		
		$(window).on('resize', function() {
			setupContainers();
			setupHotspots();
			$('#unit-dwg').panzoom('resetDimensions');
		});
		
		// Assembly group dropdown menu
		$('.dd-group-tree-menu > li > a').click(function(ev){
			ev.preventDefault();
			ev.stopPropagation();
			$(this).parent('li').toggleClass('active');			
		});
		
		setupHotspots();
      		
	}
});

function setupContainers()
{
	var dwgCol = $('#unit-dwg-col');
	var groupBtnContainerHeight = $('#group-btn-container').outerHeight(true);
	var dwgContainer = $('#unit-dwg-container');
	var availWidth = dwgCol.innerWidth() - parseInt(dwgCol.css('padding-left')) - parseInt(dwgCol.css('padding-right'));
	
	var containerHeight;
	containerHeight = $(window).height() - groupBtnContainerHeight;		
	
	dwgCol.css('min-height', groupBtnContainerHeight + containerHeight + parseInt(dwgCol.css('padding-top')) + parseInt(dwgCol.css('padding-bottom')) + 'px');
	$('#affix-left-pane').css({
		'height': groupBtnContainerHeight + containerHeight + 'px',
		'min-height': groupBtnContainerHeight + containerHeight + 'px'});
	dwgContainer.css({'width' : availWidth + 'px', 'height' : containerHeight + 'px'});
	$('.dd-group-tree-menu').css({'max-height' : containerHeight + 'px'});
}

function setupHotspots()
{
	var dwg = $('#unit-dwg');
	var dwgW = document.getElementById('unit-dwg').naturalWidth;
	var dwgH = document.getElementById('unit-dwg').naturalHeight;
	var dwgInW = dwg.innerWidth();
	var dwgInH = dwg.innerHeight();
	var containerW = $('#unit-dwg-container').innerWidth();
	var containerH = $('#unit-dwg-container').innerHeight();
	
	var matrix = dwg.panzoom('getMatrix');
	var scale = matrix[0];
	var translateX = matrix[4];
	var translateY = matrix[5];
	
	var hsScale = dwgH / (dwg.innerHeight() * scale);
	
	// Viewport projection on source image
	var srcDwgRect = {
		tl : {
			x: (dwgW - dwgW / scale) / 2 - translateX*hsScale, 				
			y: (dwgH - dwgH / scale) / 2 - translateY*hsScale },
		tr : {
			x: dwgW - 1 - (dwgW - dwgW / scale) / 2 - translateX*hsScale + (containerW - dwgInW)*hsScale, 	
			y: (dwgH - dwgH / scale) / 2 - translateY*hsScale },
		br : {
			x: dwgW - 1 - (dwgW - dwgW / scale) / 2 - translateX*hsScale + (containerW - dwgInW)*hsScale, 	
			y: dwgH - 1 - (dwgH - dwgH / scale) / 2 - translateY*hsScale + (containerH - dwgInH)*hsScale },
		bl : {
			x: (dwgW - dwgW / scale) / 2 - translateX*hsScale, 				
			y: dwgH - 1 - (dwgH - dwgH / scale) / 2 - translateY*hsScale + (containerH - dwgInH)*hsScale }
	};

	$('#unit-dwg-container .hotspot').each(function(){
		var x = $(this).data('hsleft');
		var y = $(this).data('hstop');
		var w = $(this).data('hswidth');
		var h = $(this).data('hsheight');
		
		if ((x >= srcDwgRect.tl.x) && (y >= srcDwgRect.tl.y) && (x <= (srcDwgRect.br.x - w)) && (y <= (srcDwgRect.br.y - h))) {
			if ((w != h) && (Math.abs(w - h) <= 15)) {
				var x1 = x + w/2 - Math.max(w, h)/2;
				var y1 = y + h/2 - Math.max(w, h)/2;
				w1 = Math.max(w, h);
				h1 = w1;
				if ((x1 >= srcDwgRect.tl.x) && (y1 >= srcDwgRect.tl.y) && (x1 <= (srcDwgRect.br.x - w1)) && (y1 <= (srcDwgRect.br.y - h1))) {
					x = x1;
					y = y1;
					w = w1;
					h = h1;
				}
			}
			$(this).css({
				'width': Math.floor(w / hsScale) + 'px',
				'height': Math.floor(h / hsScale) + 'px',
				'left': Math.floor((x - srcDwgRect.tl.x) / hsScale) + 'px',
				'top': Math.floor((y - srcDwgRect.tl.y) / hsScale) + 'px'
			});
			if (w == h) {
				$(this).css({'border-radius': '50%'});
			} else {
				$(this).css({'border-radius': Math.min(w, h) + 'px'});
			}
			$(this).addClass('show');
		} else {
			$(this).removeClass('show');
		}
	});
}

function formatEtkaPartNo(partNo) {
	return partNo.substr(0, 3) + '&nbsp;' + partNo.substr(3, 3) + '&nbsp;' + partNo.substr(6, 3) + '&nbsp;' + partNo.substr(9);
}

