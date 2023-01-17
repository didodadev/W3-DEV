var basketService = function() {

    if ( window.basketServiceObject === undefined ) {
        window.basketServiceObject = {};
    }
    var self = window.basketServiceObject;

    self.basketRowCalculator = null;
    self.basketSummaryCalculator = null;
    self.sharedVariables = {};

    self.getShared = function( key ) {
        if ( self.sharedVariables.hasOwnProperty(key) ) {
            return self.sharedVariables[key];
        }
        return null;
    };
    self.setShared = function( key, value ) {
        self.sharedVariables[key] = value;
    };
    
    return {
        set: self.setShared,
        get: self.getShared,
        setBasketRowCalculator: function( fn ) { self.basketRowCalculator = fn; },
        setBasketSummaryCalculator: function( fn ) { self.basketSummaryCalculator = fn; },
        basketRowCalculate: function() { return self.basketRowCalculator; },
        basketSummaryCalculate: function() { return self.basketSummaryCalculator; }
    }
}();