 < ! - - -   2 0 0 6 0 6 1 5   T o l g a S   s � r e c   s e r v i s   t a m a m l a n d1   y a   g e t i r i l d i g i n d e   v a r s a   c i k i s   i r s a l i y e s i   n o l a r1 n1   y a z a c a k   - - - >  
 < c f q u e r y   n a m e = " g e t _ s h i p s "   d a t a s o u r c e = " # a t t r i b u t e s . d a t a _ s o u r c e # " >  
 	 S E L E C T   S H I P _ I D , S H I P _ N U M B E R   F R O M   # c a l l e r . d s n 2 _ a l i a s # . S H I P   W H E R E   S E R V I C E _ I D   =   # a t t r i b u t e s . a c t i o n _ i d #   A N D   S H I P _ T Y P E = 1 4 1  
 < / c f q u e r y >  
 < c f o u t p u t   q u e r y = " g e t _ s h i p s " >  
 	 < c f s e t   a t t r i b u t e s . w a r n i n g _ d e s c r i p t i o n = ' # a t t r i b u t e s . w a r n i n g _ d e s c r i p t i o n #  0 r s   N o # c u r r e n t r o w # :   # S H I P _ N U M B E R # ' >  
 < / c f o u t p u t >  

