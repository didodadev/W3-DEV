var basketManager = function() {
    if ( window.basketManagerObject === undefined ) 
        window.basketManagerObject = {};
    var self = window.basketManagerObject;

    //basket verileri
    self.basketInfo = {};
    self.basketHeaders = ko.observableArray([]);
    self.basketItems = ko.observableArray([]);
    self.basketFooter = {
        basket_gross_total: ko.observable(0),
        basket_tax_total: ko.observable(0),
        basket_otv_total: ko.observable(0),
        basket_net_total: ko.observable(0),
        basket_discount_total: ko.observable(0),
        basket_money: ko.observable(''),
        basket_rate1: ko.observable(1),
        basket_rate2: ko.observable(1),
        genel_indirim: ko.observable(0),
        kur_say: ko.observable(0),
        yuvarlama: ko.observable(0),
        yuvarlama_doviz: ko.observable(0),
        basketCurrencyType: ko.observable(''),
        general_taxs: ko.observableArray([]),
        totalAmount: ko.observableArray([]),
        totalOivAmount: ko.observableArray([]),
        totalBsmvAmount: ko.observableArray([]),
        total_oiv_default: ko.observable(0),
        total_oiv: ko.observable(0),
        total_bsmv_default: ko.observable(0),
        total_bsmv: ko.observable(0),
        is_general_prom: ko.observable(false),
        total_wanted: ko.observable(0),
        total_tax_wanted: ko.observable(0),
        total_otv_wanted: ko.observable(0),
        total_oiv_wanted: ko.observable(0),
        total_bsmv_wanted: ko.observable(0),
        total_discount_wanted: ko.observable(0),
        net_total_wanted: ko.observable(0),
        old_general_prom_amount: ko.observable(0),
        general_prom_amount: ko.observable(0),
        general_prom_limit: ko.observable(0),
        general_prom_discount: ko.observable(0),
        general_prom_id: ko.observable(''),
        prom_list: ko.observableArray([]),
        free_prom_limit: ko.observable(0),
        free_prom_stock_id: ko.observable(0),
        free_prom_id: ko.observable(''),
        free_prom_cost: ko.observable(''),
        free_prom_amount: ko.observable(0),
        free_prom_stock_price: ko.observable(0),
        free_prom_stock_money: ko.observable(''),
        department_array: ko.observableArray([]),
        commission_rate: ko.observable(0),
        tevkifat_oran: ko.observable(0),
        tevkifat_id: ko.observable(''),
        is_tevkifat: ko.observable(false),
        tev_kdv_list: ko.observableArray([]),
        bey_kdv_list: ko.observableArray([]),
        stopaj_yuzde: ko.observable(0),
        stopaj: ko.observable(0),
        stopaj_id: ko.observable(''),
        is_stopaj: ko.observable(false),
        exc_id: ko.observable(""),
        exc_code: ko.observable(""),
        exc_article: ko.observable(""),
        duedate: ko.observable(""),
        genel_indirim_doviz_net_hesap: ko.observable(0),
        genel_indirim_doviz_brut_hesap: ko.observable(0),
        genel_indirim_kdvli_hesap: ko.observable(0),
        brut_total_default: ko.observable(0),
        brut_total_wanted: ko.observable(0),
        general_otv: ko.observableArray([]),
        TotalOtvDiscount : ko.observableArray([]),
        prom_items_discount: ko.observableArray([]),
        prom_items_free: ko.observableArray([]),
        cash_list: ko.observableArray([]),
        pos_list: ko.observableArray([])
    };

    self.basketFooter.total_cash_amount = ko.computed(function(){
        var totalMoney = 0.0;
        
        if( self.basketFooter.cash_list().length > 0 ){
            self.basketFooter.cash_list().forEach((el) => {
                var moneyArrayLen = moneyArray.length;
                for (let moni = 0; moni < moneyArrayLen; moni++) {
                    if ( moneyArray[moni] == el.currency_type ) {
                        totalMoney += el.cash_amount() != '' ? parseFloat( filterNum( commaSplit( el.cash_amount() ) ) * rate2Array[moni] / rate1Array[moni] ) : 0;
                    }
                }
            });
        }

        if( self.basketFooter.pos_list().length > 0 ){
            self.basketFooter.pos_list().forEach((el) => {
                var money = el.items.filter( (elm) => { return elm.ID == el.pos() } );
                if(money.length > 0){
                    var moneyArrayLen = moneyArray.length;
                    var currency_type = money[0].ID.split(';')[1];
                    for (let moni = 0; moni < moneyArrayLen; moni++) {
                        if ( moneyArray[moni] == currency_type ) {
                            totalMoney += el.pos_amount() != '' ? parseFloat( filterNum( commaSplit( el.pos_amount() ) ) * rate2Array[moni] / rate1Array[moni] ) : 0;
                        }
                    }
                }
            });
        }

        return totalMoney;
    });

    self.basketFooter.diff_amount = ko.computed(function(){
        return self.basketFooter.basket_net_total() - self.basketFooter.total_cash_amount();
    });

    self.basketFooter.card_amount = ko.computed(function(){
        var totalMoney = 0.0;

        if( self.basketFooter.pos_list().length > 0 ){
            self.basketFooter.pos_list().forEach((el) => {
                var money = el.items.filter( (elm) => { return elm.ID == el.pos() } );
                if(money.length > 0){
                    var moneyArrayLen = moneyArray.length;
                    var currency_type = money[0].ID.split(';')[1];
                    for (let moni = 0; moni < moneyArrayLen; moni++) {
                        if ( moneyArray[moni] == currency_type ) {
                            totalMoney += el.pos_amount() != '' ? parseFloat( filterNum( commaSplit( el.pos_amount() ) )* rate2Array[moni] / rate1Array[moni] ) : 0;
                        }
                    }
                }
            });
        }
        return totalMoney;
    });

    self.basketFooter.cash_amount = ko.computed(function(){
        var totalMoney = 0.0;
        
        if( self.basketFooter.cash_list().length > 0 ){
            self.basketFooter.cash_list().forEach((el) => {
                var moneyArrayLen = moneyArray.length;
                for (let moni = 0; moni < moneyArrayLen; moni++) {
                    if ( moneyArray[moni] == el.currency_type ) {
                        totalMoney += el.cash_amount() != '' ? parseFloat( filterNum( commaSplit( el.cash_amount() ) ) * rate2Array[moni] / rate1Array[moni] ) : 0;
                    }
                }
            });
        }

        return totalMoney;
    });


    self.basketHeadersForVisible = ko.computed(function() {
        return self.basketHeaders().filter(m => m.isVisible);
    });

    //shared değişkenler
    self.activeRowIndex = ko.observable(-1);
    self.activeColIndex = ko.observable(-1);
    self.duedate = ko.observable("0,00");
    self.discount = {};
    self.activePopupTemplate = ko.observable('');
    self.activePopupData = ko.observable(null);

    //Paging

    self.PageSize = ko.observable(0);
    self.CurrentPage = ko.observable(1);
    self.TotalCount = ko.observable(0);

    self.PageCount = ko.pureComputed(function () {
        return Math.ceil(self.TotalCount() / self.PageSize());
    });
    self.maxPageCount = 5;
    self.FirstPage = 1;
    self.LastPage = ko.pureComputed(function () {
        return self.PageCount();
    });
    self.SetCurrentPage = function (page) {
        if (page < self.FirstPage)
            page = self.FirstPage;

        if (page > self.LastPage())
            page = self.LastPage();

        self.CurrentPage(page);
    };
    self.NextPage = ko.pureComputed(function () {
        var next = self.CurrentPage() + 1;
        if (next > self.LastPage())
            return null;
        return next;
    });

    self.PreviousPage = ko.pureComputed(function () {
        var previous = self.CurrentPage() - 1;
        if (previous < self.FirstPage)
            return null;
        return previous;
    });

    self.NeedPaging = ko.pureComputed(function () {
        return self.PageCount() > 1;
    });

    self.NextPageActive = ko.pureComputed(function () {
        return self.NextPage() != null;
    });

    self.PreviousPageActive = ko.pureComputed(function () {
        return self.PreviousPage() != null;
    });

    self.LastPageActive = ko.pureComputed(function () {
        return (self.LastPage() != self.CurrentPage());
    });

    self.FirstPageActive = ko.pureComputed(function () {
        return (self.FirstPage != self.CurrentPage());
    });

    self.Update = function (e) {
        self.TotalCount(e.TotalCount);
        self.PageSize(e.PageSize);
        self.SetCurrentPage(e.CurrentPage);
    };

    self.generateAllPages = function () {
        var pages = [];
        for (var i = self.FirstPage; i <= self.LastPage(); i++) pages.push(i);
        return pages;
    };

    self.generateMaxPage = function () {
        var current = self.CurrentPage();
        var pageCount = self.PageCount();
        var first = self.FirstPage;

        var upperLimit = current + parseInt((self.maxPageCount - 1) / 2);
        var downLimit = current - parseInt((self.maxPageCount - 1) / 2);

        while (upperLimit > pageCount) {
            upperLimit--;
            if (downLimit > first)
                downLimit--;
        }

        while (downLimit < first) {
            downLimit++;
            if (upperLimit < pageCount)
                upperLimit++;
        }

        var pages = [];
        for (var i = downLimit; i <= upperLimit; i++) {
            pages.push(i);
        }
        return pages;
    };

    self.GetPages = ko.computed(function () {
        
        if (self.PageCount() <= self.maxPageCount) {
            return self.generateAllPages();
        } else {
            return self.generateMaxPage();
        }
    });

    self.GoToPage = function( page ){
        if( page >= self.FirstPage && page <= self.LastPage()) self.SetCurrentPage(page);
        else if( page == 'first' ) self.SetCurrentPage(self.FirstPage);
        else if( page == 'last' ) self.SetCurrentPage(self.LastPage());
        else if( page == 'prev' && self.PreviousPage() != null ) self.SetCurrentPage(self.PreviousPage());
        else if( page == 'next' && self.NextPage() != null ) self.SetCurrentPage(self.NextPage());
    }

    self.basketItemsView = ko.computed( function(){
        var result = [];
        var startIndex = (self.CurrentPage() - 1) * self.PageSize();
        var endIndex = self.CurrentPage() * self.PageSize();

        for (var i = startIndex; i < endIndex; i++) {
            if (i < self.basketItems().length)
                result.push(self.basketItems()[i])
        }
        return result;
    });

    
    //basket işlem metodları

    //basket başlık ekle
    self.appendHeaderInfo = function( headerItem ) {
        let headerItemObject = {
            title: headerItem.TITLE_NAME,
            width: headerItem.GENISLIK,
            isReadonly: headerItem.IS_READONLY == 1,
            isRequired: headerItem.IS_REQUIRED == 1,
            isVisible: headerItem.IS_SELECTED == 1,
            id: headerItem.TITLE.toLowerCase(),
            isNumeric: headerItem.IS_NUMERIC,
            isAmount: headerItem.IS_AMOUNT,
            isHesapla: headerItem.IS_HESAPLA,
            isLV: headerItem.IS_LV,
            sale_product: headerItem.PURCHASE_SALES,
            isPopup: headerItem.IS_POPUP
        };
        self.basketHeaders.push(headerItemObject);
        if (headerItemObject.id.indexOf('disc_ount') >= 0) {
            self.discount[headerItemObject.id] = ko.observable(0);
        }
    };

    //basket izinlere göre readonly durumu
    self.setBasketReadonly = function( ids ) {
        self.basketHeaders().forEach((m) => {
            let idsIndex = ids.indexOf(m.id); 
            if (idsIndex >= 0) {
                m.isReadonly = true;
            }
        });
    };

    //basket izinlere göre gizlenir
    self.setBasketHidden = function( ids ) {
        self.basketHeaders().forEach((m) => {
            let idsIndex = ids.indexOf(m.id); 
            if (idsIndex >= 0) {
                m.isVisible = false;
            }
        });
    };

    //basket footer set et
    self.setBasketFooterItem = function( key, value ) {
        if (self.basketFooter.hasOwnProperty(key)) {
            self.basketFooter[key]( value );
        } else {
            self.basketFooter[key] = value;
        }
    }

    //basket satırları ekle
    self.appendItems = function( bodyItem ) {
        var bodyItemObject = {};
        for (let key in bodyItem) {
            if (bodyItem.hasOwnProperty(key)) {
                let headerRels = self.basketHeaders().filter( m => m.id == key.toLowerCase() );
                bodyItemObject[key.toLowerCase()] = ko.observable( 
                    headerRels.length > 0 && headerRels[0].isNumeric 
                    ? ( isNaN(bodyItem[key].toString()) 
                        ? commaSplit( bodyItem[key].toString() ) 
                        : ( bodyItem[key] != '' 
                            ? parseFloat( bodyItem[key].toString() ) 
                            : 0 ) 
                    ) : bodyItem[key] );
            }
        }
        self.basketHeaders().forEach((m) => {
            if (!bodyItemObject.hasOwnProperty(m.id.toLowerCase())) {
                bodyItemObject[m.id.toLowerCase()] = ko.observable( m.isNumeric ? 0 : '' );
            }
            if (m.isLV) {
                bodyItemObject["displayfor_" + m.id.toLowerCase()] = ko.computed(function () {
                    let uvalue = ko.unwrap(bodyItemObject[m.id.toLowerCase()]);
                    let nvalue = ko.observable(uvalue);
                    return lv_factory( m.id.toLowerCase(), nvalue);
                });
            }
        });
        self.basketItems.push(bodyItemObject);
    }

    //native events
    self.onDuedateBlur = function() {
        if (self.basketFooter.duedate() == "") self.basketFooter.duedate(0);
    };
    self.onDuedateFocus = function() {
        if (self.basketFooter.duedate() == "0,00") self.duedate("");
    };

    return {
        init: function() {
            ko.options.deferUpdates = true;
            ko.applyBindings( self, document.getElementById("basket-container") );
        },
        setBasketHeader: function( basketData ) {
            basketData.forEach(item => {
                self.appendHeaderInfo( item );
            });
        },
        setBasketItems: function( basketItems ) {
            basketItems.forEach(item => {
                self.appendItems( item );
            });
        },
        setBasketHidden: function( ids ) {
            self.setBasketHidden( ids );
        },
        setBasketFooterItem: function( key, value ) {
            self.setBasketFooterItem( key, value );
        },
        hasShownItem: function( key ) {
            return self.basketHeadersForVisible().filter(e => e.id == key).length > 0;
        },
        getBasketRow: function( idx ) {
            if ( self.basketItems().length < idx ) return null;
            return self.basketItems()[idx];
        },
        setActivePopup: function(name, data) {
            self.activePopupTemplate(name);
            self.activePopupData(data);
        },
        getBasketJSON() {
            return ko.mapping.toJSON(self.basketItems);
        },
        getSummaryJSON() {
            return ko.mapping.toJSON(self.basketFooter);
        },
        getBasketColumnProperties : function( basketColumnId ){
            return self.basketHeadersForVisible().filter( ( item ) => { return basketColumnId == item.id  } );
        },
        setPaging: function(){
            self.PageSize( basketService.line_number() );
            self.TotalCount( self.basketItems().length );
        }
    }
}();