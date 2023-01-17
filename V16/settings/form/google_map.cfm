<!---
    Şubelerde, koordinatların belirkenmesi, adresin koordinatlarının bulunması, koordinatları var olan şubelerin haritada gösterilmesinin,
    Google Map API kullanılarak yapılması için oluşturulmuştur.
    Alper ÇİTMEN - 25.09.2021
--->
<cfscript>
    if( isDefined("attributes.branchId") and len(attributes.branchId) ){
        removeChar = Replace(attributes.branchId, '[', '', 'ALL');
        branchIds = Replace(removeChar, ']', '', 'ALL');
    }
</cfscript>
<cf_box title="#getLang('','Şubeler',29434)# - #getLang('','Harita',34357)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" style="left: 0;top: 0;height: 80vh !important;" >
    <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
    <cfset get_api_key = googleapi.get_api_key()>
    <cfif isDefined("attributes.address")>
        <cfset address = attributes.address>
    <cfelse>
        <cfset address = "">
    </cfif>
    <cfif isDefined("attributes.long")>
        <cfset lng = attributes.long>
    <cfelse>
        <cfset lng = "35">
    </cfif>
    <cfif isDefined("attributes.lat")>
        <cfset lat = attributes.lat>
    <cfelse>
        <cfset lat = "40">
    </cfif>
    <cfif isDefined("attributes.zoom")>
        <cfset zoom = attributes.zoom>
    <cfelse>
        <cfset zoom = "8">
    </cfif>
    <cfset coords2 = arrayNew(1)>
    <div class="col col-12">
        <cfif isDefined("attributes.type") and attributes.type eq 'list'>
            <cfset coordinates = []>
            <cfset count = 1>
            <div id="pac-container">
                <div class="col col-2">
                    <table class="table">
                        <thead>
                            <tr>
                                <td style="background-color:#ccc;padding:5px 0 5px 7px;" colspan="2" class="bold"><cf_get_lang dictionary_id='29434.Şubeler'></td>
                            </tr>
                        </thead>
                        <cfloop array="#listToArray(branchIds)#" index="i">
                            <cfquery name="get_branches" datasource="#dsn#">
                                SELECT
                                    BRANCH.BRANCH_ID,
                                    BRANCH.BRANCH_NAME,
                                    BRANCH.COORDINATE_1,
                                    BRANCH.COORDINATE_2
                                FROM
                                    BRANCH
                                WHERE
                                    BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                            </cfquery>
                            <cfoutput>
                                <tbody>
                                    <tr>
                                        <td>#count#</td>
                                        <td><a href="#request.self#?fuseaction=hr.list_branches&event=upd&id=#get_branches.BRANCH_ID#" target="_blank">#get_branches.branch_name#</a>
                                        </td>
                                    </tr>
                                </tbody>
                            </cfoutput>
                            <cfset count++>
                            <cfif len(get_branches.coordinate_1) and len(get_branches.coordinate_2)>
                                <cfset ArrayAppend(coordinates, "[{ lat: #get_branches.coordinate_1#, lng: #get_branches.coordinate_2# },  '#get_branches.branch_name#'];") />
                            </cfif>
                        </cfloop>
                    </table>
                </div>
                <cfif arrayLen(coordinates)>
                    <cfset coords = coordinates.toString()>
                    <cfset coords2 = listToArray(coords,";[]")>
                <cfelse>
                    <cfset coords2 = arrayNew(1)>
                </cfif>
                <div>
                    <input
                        id="pac-input"
                        class="pac-item"
                        type="text"
                        placeholder="<cf_get_lang dictionary_id='34339.Adres Ara'>"
                        value="<cfoutput>#address#</cfoutput>"
                        style="width:250px;"
                    />
                    <input type="button" id="searchbutton" value="<cf_get_lang dictionary_id='57565.Ara'>">
                    <div id="map-canvas" class="col col-10 col-md-10 col-sm-10" style="position: absolute;left: 0;width: 82% !important;height: 100% !important; left:18%">
                    </div>
                </div>
            </div>
        <cfelse>
            <span id="c"></span>
            <div id="pac-container">
                <input
                    id="pac-input"
                    class="pac-item"
                    type="text"
                    placeholder="<cf_get_lang dictionary_id='34339.Adres Ara'>"
                    value="<cfoutput>#address#</cfoutput>"
                    style="width:250px;"
                />
                <input type="button" id="searchbutton" value="<cf_get_lang dictionary_id='57565.Ara'>">
                <div id="map-canvas" class="col col-12 col-md-12 col-sm-12" style="height:500px">
                </div>
            </div>
        </cfif>
    </div>
    <cf_box_footer>
        <cfif isDefined("attributes.type") and attributes.type neq 'list'>
            <a href="javascript://" onclick="initialize()"><cf_get_lang dictionary_id='65289.Haritayı açmak için tıklayın'></a>
        </cfif>
    </cf_box_footer>
</cf_box>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>&libraries=places"></script>
<script type="text/javascript">
    function initialize() {
        const map = new google.maps.Map(document.getElementById("map-canvas"), {
            zoom:  <cfoutput>#zoom#</cfoutput>,
            center: { lat: <cfoutput>#lat#</cfoutput>, lng: <cfoutput>#lng#</cfoutput> },
            mapTypeId: "roadmap"
        });
        // Birden fazla konuma marker koymak için array oluşturuluyor
        const tourStops = [
            <cfloop array="#coords2#" index="index">
                <cfoutput>
                    [#index#],
                </cfoutput>
            </cfloop>
        ];

        // Marker'larda kullanmak için info window oluşturuluyor.
        const infoWindow = new google.maps.InfoWindow();
        // Marker oluşturuluyor.
        tourStops.forEach(([position, title], i) => {
            const marker = new google.maps.Marker({
                position,
                map,
                title: `${title}`,
                /* label: `${i + 1}`, */
                optimized: true,
            });

            // Tıklanan marker'a ait bilgileri gösteriyor.
            marker.addListener('click', function(){
                infoWindow.close();
                infoWindow.setContent(marker.getTitle());
                infoWindow.open(marker.getMap(), marker);
            });
        });

        // Haritada tıklanan yerin koordinatlarını alıyor, marker ve eklemek için uyarı yazısı oluşturuyor
        map.addListener("click", (mapsMouseEvent) => {
            infoWindow.close();
            <cfif isDefined("attributes.type") and attributes.type eq 'upd' or attributes.type eq 'add'>
                var clickedLat = mapsMouseEvent.latLng.lat();
                var clickedLng = mapsMouseEvent.latLng.lng();
                $("#c").html("<div style='padding:10px; display:flex; align-items:center;' class='col col-12'><span class='col col-6 bold'><cfoutput>#getLang('','Koordinatlar',58549)#</cfoutput>: " + clickedLat + " | " + clickedLng + " " + "</span><span class='col col-1'><a class='ui-btn ui-btn-green' href='javascript://' onclick='addCorrd("+clickedLat+","+clickedLng+");'><cfoutput>#getLang('','Ekle',44630)#</cfoutput></a></span></div>");
                let markers = [];
                map.addListener("click", (event) => {
                    clearOverlays();
                    addMarker(event.latLng);
                });
                function addMarker(position) {
                    const marker = new google.maps.Marker({
                        position,
                        map,
                    });

                    markers.push(marker);
                }
                function clearOverlays() {
                    for (var i = 0; i < markers.length; i++ ) {
                    markers[i].setMap(null);
                    }
                }

                // Tıklanan marker'a ait bilgileri gösteriyor.
                markers.addListener('click', function(){
                    infoWindow.close();
                    infoWindow.setContent(markers.getTitle());
                    infoWindow.open(markers.getMap(), markers);
                });
            </cfif>
        });

        // Adres arama input box oluşturuyor.
        const input = document.getElementById("pac-input");
        const searchbutton = document.getElementById("searchbutton");
        const searchBox = new google.maps.places.SearchBox(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
        map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchbutton);
        // Bias the SearchBox results towards current map's viewport.
        map.addListener("bounds_changed", () => {
            searchBox.setBounds(map.getBounds());
        });

        let markers = [];
        // Adres aramsı yapıldığında...
        searchBox.addListener("places_changed", () => {
            const places = searchBox.getPlaces();

            if (places.length == 0) {
                return;
            }
            // Önceden eklenmiş marker'ları siliyor
            markers.forEach((marker) => {
                marker.setMap(null);
            });
            markers = [];
            // icon, name, location.
            const bounds = new google.maps.LatLngBounds();
            places.forEach((place) => {
                if (!place.geometry || !place.geometry.location) {
                    console.log("Returned place contains no geometry");
                    return;
                }

                const icon = {
                    url: place.icon,
                    size: new google.maps.Size(71, 71),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(17, 34),
                    scaledSize: new google.maps.Size(25, 25),
            };
            // Marker oluşturuyor
            markers.push(
                new google.maps.Marker({
                    map,
                    title: place.name,
                    position: place.geometry.location,
                    optimized: true
                })
            );

            // Arama sonrası eklenen marker'a tıklanınca koordinatları alıp üstte uyarı veriyor.
            markers[0].addListener('click', function(){
                infoWindow.close();
                infoWindow.setContent(markers[0].getTitle());
                infoWindow.open(markers[0].getMap(), markers[0]);
                <cfif isDefined("attributes.type") and attributes.type eq 'upd' or attributes.type eq 'add'>
                    var clickedLat = markers[0].position.lat();
                    var clickedLng = markers[0].position.lng();
                    $("#c").html("<span class='bold'><cfoutput>#getLang('','Koordinatlar',58549)#</cfoutput>:" + clickedLat + " " + clickedLng + " " + "<a href='javascript://' onclick='addCorrd("+clickedLat+","+clickedLng+")'>Ekle</a></span>");
                    console.log(markers[0]);
                </cfif>
            });

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
            });
            map.fitBounds(bounds);
        });

        // Buton ile adres arama için
        document.getElementById('searchbutton').onclick = function () {
            var input = document.getElementById('pac-input');
            google.maps.event.trigger(input, 'focus', {});
            google.maps.event.trigger(input, 'keydown', { keyCode: 13 });
            google.maps.event.trigger(this, 'focus', {});
        };
    }

    /* google.maps.event.addDomListener(window, 'load', function(){ initialize(); }); */
    const myTimeout = setTimeout(initialize, 2000);

    // Arama sonrası bulunan koordinatları, upd sayfasındaki inputlara eklemek için.
    function addCorrd(clickedLat, clickedLng, address = ""){
        <cfif isDefined("attributes.draggable")>
            $('#coordinate_1').val(clickedLat); // lat - enlem
            $('#coordinate_2').val(clickedLng); // lng - boylam
            alert("<cf_get_lang dictionary_id='58549.Koordinatlar'><cf_get_lang dictionary_id='33728.Eklendi'>");
        <cfelse>
            window.opener.document.getElementById("coordinate_1").value = clickedLat;
            window.opener.document.getElementById("coordinate_2").value = clickedLng;
            /* <cfif isDefined("attributes.type") and attributes.type eq "add">
                window.opener.document.getElementById("branch_address").value = address;
            </cfif> */
            alert("<cf_get_lang dictionary_id='58549.Koordinatlar'><cf_get_lang dictionary_id='33728.Eklendi'>");
        </cfif>
    }
</script>