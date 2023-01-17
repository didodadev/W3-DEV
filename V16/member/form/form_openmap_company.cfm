<!--- <cfdump  var="#attributes#" abort> --->
<!---
    Kurumsal Hesaplarda, koordinatların belirlenmesi ve haritada gösterilmesinin,
    Google Map API kullanılarak yapılması için oluşturulmuştur.
    Alper ÇİTMEN - 30.09.2021
--->
<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_box title="#getLang('','Google Harita',63424)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> <span id="c"></span>
    <script src="https://code.jquery.com/jquery-3.6.0.slim.js" integrity="sha256-HwWONEZrpuoh951cQD1ov2HUK5zA5DwJ1DNUXaM6FsY=" crossorigin="anonymous"></script>
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>&libraries=places"></script>
        <cfif isDefined("attributes.address")>
            <cfset address = attributes.address>
        <cfelse>
            <cfset address = "">
        </cfif>
        <cfif isDefined("attributes.lng")>
            <cfset lng = attributes.lng>
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
            <cfset zoom = "9">
        </cfif>
        
        <script type="text/javascript">
            function initialize() {
                const map = new google.maps.Map(document.getElementById("map-canvas"), {
                    zoom:  <cfoutput>#zoom#</cfoutput>,
                    center: { lat: <cfoutput>#lat#</cfoutput>, lng: <cfoutput>#lng#</cfoutput> },
                    mapTypeId: "roadmap"
                });
                const marker = new google.maps.Marker({
                    position: { lat: <cfoutput>#lat#</cfoutput>, lng: <cfoutput>#lng#</cfoutput> },
                    map,
                    title: "<cfoutput>#attributes.title#</cfoutput>",
                    optimized: true,
                });

                // Tıklanan marker'a ait bilgileri gösteriyor.
                const infoWindow = new google.maps.InfoWindow();
                marker.addListener('click', function(){
                    infoWindow.close();
                    infoWindow.setContent(marker.getTitle());
                    infoWindow.open(marker.getMap(), marker);
                    <cfif isDefined("attributes.type") and attributes.type eq 'det' or attributes.type eq 'add'>
                        var clickedLat = marker.position.lat();
                        var clickedLng = marker.position.lng();
                        $("#c").html("<span class='bold'><cfoutput>#getLang('','Koordinatlar',58549)#</cfoutput>:" + clickedLat + " " + clickedLng + " " + "<a href='javascript://' onclick='addCorrd("+clickedLat+","+clickedLng+")'>Ekle</a></span>");
                    </cfif>
                });
                
                // Haritada tıklanan yerin koordinatlarını alıyor, marker ve eklemek için uyarı yazısı oluşturuyor
                map.addListener("click", (mapsMouseEvent) => {
                    infoWindow.close();
                    <cfif isDefined("attributes.type") and attributes.type eq 'det' or attributes.type eq 'add'>
                        var clickedLat = mapsMouseEvent.latLng.lat();
                        var clickedLng = mapsMouseEvent.latLng.lng();
                        $("#c").html("<span class='bold'><cfoutput>#getLang('','Koordinatlar',58549)#</cfoutput>:" + clickedLat + " " + clickedLng + " " + "<a href='javascript://' onclick='addCorrd("+clickedLat+","+clickedLng+");'>Ekle</a></span>");
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
                            marker.setMap(null);
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
                        <cfif isDefined("attributes.type") and attributes.type eq 'det' or attributes.type eq 'add'>
                            var clickedLat = markers[0].position.lat();
                            var clickedLng = markers[0].position.lng();
                            $("#c").html("<span class='bold'><cfoutput>#getLang('','Koordinatlar',58549)#</cfoutput>:" + clickedLat + " " + clickedLng + " " + "<a href='javascript://' onclick='addCorrd("+clickedLat+","+clickedLng+")'>Ekle</a></span>");
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
            
            google.maps.event.addDomListener(window, 'load', function(){ initialize(); });
            
            // Arama sonrası bulunan koordinatları, det sayfasındaki inputlara eklemek için.
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
</cf_box>