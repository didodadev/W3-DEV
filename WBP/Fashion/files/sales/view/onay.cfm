<!DOCTYPE html>
<html>

<head>
    <title>JQM Swipe Delete</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.3/jquery.mobile-1.4.3.min.css" />
    <style>
    .behind {
        width: 100%;
        height: 100%;
        position: absolute;
        top: 0;
        right: 0;
    }
    .behind a.ui-btn {
        width: 68px;
        margin: 0px;
        float: right;
        border: none;
    }
    .behind a.delete-btn, .behind a.delete-btn:active, .behind a.delete-btn:visited, .behind a.delete-btn:focus, .behind a.delete-btn:hover {
        color: white;
        background-color: red;
        text-shadow: none;
    }
    .behind a.ui-btn.pull-left {
        float: left;
    }
    .behind a.edit-btn, .behind a.edit-btn:active, .behind a.edit-btn:visited, .behind a.edit-btn:focus, .behind a.edit-btn:hover {
        color: white;
        background-color: orange;
        text-shadow: none;
    }
    </style>
</head>


<cfquery name="get_emp" datasource="#DSN#">
	select top 200 EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME as name from EMPLOYEES
</cfquery>




<body>
    <div id="container">
        <div data-role="page">
            <div data-role="header" data-position="fixed">
                <h1>Swipe Delete</h1>
            </div>
            <div data-role="content">
                <ul data-role="listview" class="swipe-delete">
					<cfoutput query="get_emp">
						<li>
							<div class="behind">
								<a href="" class="ui-btn delete-btn">Delete</a>
								<a href="" class="ui-btn edit-btn pull-left">Edit</a>
							</div>
							<a href="">#name#</a>
						</li>
					</cfoutput>
                </ul>
            </div>
        </div>
    </div>
</body>

<script type="text/javascript" src="/WBP/Fashion/files/js/jquery.mobile-1.4.3.min.js"></script>
<script type="text/javascript">
$(function() {

    function prevent_default(e) {
        e.preventDefault();
    }

    function disable_scroll() {
        $(document).on('touchmove', prevent_default);
    }

    function enable_scroll() {
        $(document).unbind('touchmove', prevent_default)
    }

    var x;
    $('.swipe-delete li > a')
        .on('touchstart', function(e) {
            console.log(e.originalEvent.pageX)
            $('.swipe-delete li > a.open').css('left', '0px').removeClass('open') // close em all
            $(e.currentTarget).addClass('open')
            x = e.originalEvent.targetTouches[0].pageX // anchor point
        })
        .on('touchmove', function(e) {
            var change = e.originalEvent.targetTouches[0].pageX - x
            change = Math.min(Math.max(-100, change), 100) // restrict to -100px left, 0px right
            e.currentTarget.style.left = change + 'px'
            if (change < -10) disable_scroll() // disable scroll once we hit 10px horizontal slide
        })
        .on('touchend', function(e) {
            var left = parseInt(e.currentTarget.style.left)
            var new_left;
            if (left < -35) {
                new_left = '-100px'
            } else if (left > 35) {
                new_left = '100px'
            } else {
                new_left = '0px'
            }
            // e.currentTarget.style.left = new_left
            $(e.currentTarget).animate({left: new_left}, 200)
            enable_scroll()
        });

    $('li .delete-btn').on('touchend', function(e) {
        e.preventDefault()
        $(this).parents('li').slideUp('fast', function() {
            $(this).remove()
        })
    })

    $('li .edit-btn').on('touchend', function(e) {
        e.preventDefault()
        $(this).parents('li').children('a').html('edited')
    })

});
</script>

</html>