xquery version '3.0' ;
module namespace GBiblio = 'synopsx.globalsBiblio';
(:~
 : This module gives the globals bibliographical variables for SynopsX
 : @version 0.2 (Constantia edition)
 : @date 2015-01-20 
 : @author synopsx team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 : @rmq params names taken from CSL specification when possible http://citationstyles.org
 :)

(:~
 : variable initiatialize with hypene
 : true or false
 :)
 declare variable $GBiblio:initialize-with-hyphene := 'true' ;
 
(:~
 : variable page range-format
 : @values expanded, ...
 :)
 declare variable $GBiblio:page-range-format := 'expanded' ;

(:~
 : variable and
 : Specifies the delimiter between the second to last and last name of the 
 : names in a name variable. Allowed values are "text" (selects the "and" 
 : term, e.g. "Doe, Johnson and Smith") and "symbol" (selects the ampersand, 
 : e.g. "Doe, Johnson & Smith").
 : @values text, symbol
 :)
declare variable $GBiblio:and := 'text' ;
 
(:~
 : variable delimiter
 : Specifies the text string used to separate names in a name variable. 
 : Default is ", " (e.g. "Doe, Smith")
 :)
declare variable $GBiblio:delimiter := ', ' ;

(:~
 : variable delimiter-precedes-et-al
 : Determines when the name delimiter or a space is used between a truncated 
 : name list and the "et-al" (or "and others") term in case of et-al abbreviation. 
 : Allowed values:
 : "contextual" - (default), name delimiter is only used for name lists truncated to two or more names 1 name: "J. Doe et al.", 2 names: "J. Doe, S. Smith, et al."
 : "after-inverted-name" - name delimiter is only used if the preceding name is inverted as a result of the name-as-sort-order attribute. E.g. with name-as-sort-order set to "first": "Doe, J., et al.", "Doe, J., S. Smith et al.", 
 : "always" - name delimiter is always used name: "J. Doe, et al.", 2 names: "J. Doe, S. Smith, et al.", 
 : "never" - name delimiter is never used, 1 name: "J. Doe et al.", 2 names: "J. Doe, S. Smith et al."
 :
 :)
declare variable $GBiblio:delimiter-precedes-et-al := 'always' ;

(:~
 : variable delimiter-precedes-last
 : Determines when the name delimiter is used to separate the second to last 
 : and the last name in name lists (if and is not set, the name delimiter is 
 : always used, regardless of the value of delimiter-precedes-last).
 : Allowed values:
 : "contextual" - (default), name delimiter is only used for name lists with three or more names : 2 names: "J. Doe and T. Williams", 3 names: "J. Doe, S. Smith, and T. Williams"
 : "after-inverted-name" - name delimiter is only used if the preceding name is inverted as a result of the name-as-sort-order attribute. E.g. with name-as-sort-order set to "first": "Doe, J., and T. Williams", "Doe, J., S. Smith and T. Williams", 
 : "always" - name delimiter is always used, 2 names: "J. Doe, and T. Williams", 3 names: "J. Doe, S. Smith, and T. Williams"
 : "never" - name delimiter is never used, 2 names: "J. Doe and T. Williams", 3 names: "J. Doe, S. Smith and T. Williams" 
 :)
declare variable $GBiblio:delimiter-precedes-last := 'always' ;

(:~
 : variables et-al-min / et-al-use-first
 : Use of these two attributes enables et-al abbreviation. If the number of 
 : names in a name variable matches or exceeds the number set on et-al-min, the 
 : rendered name list is truncated after reaching the number of names set on 
 : et-al-use-first. The "et-al" (or "and others") term is appended to truncated 
 : name lists (see also Et-al). By default, when a name list is truncated to a 
 : single name, the name and the "et-al" (or "and others") term are separated 
 : by a space (e.g. "Doe et al."). When a name list is truncated to two or 
 : more names, the name delimiter is used (e.g. "Doe, Smith, et al."). 
 : This behavior can be changed with the delimiter-precedes-et-al attribute.
 :)
declare variable $GBiblio:et-al-min := '3' ;
declare variable $GBiblio:et-al-use-first := '3' ;

(:~
 : variables et-al-subsequent-min / et-al-subsequent-use-first
 : If used, the values of these attributes replace those of respectively 
 : et-al-min and et-al-use-first for subsequent cites (cites referencing 
 : earlier cited items).
 :)
(: declare variable $GBiblio:et-al-subsequent-min := '' ; :)
(: declare variable $GBiblio:et-al-subsequent-use-first := '' ; :)

(:~
 : form
 : Specifies whether all the name-parts of personal names should be displayed 
 : (value "long", the default), or only the family name and the non-dropping-particle 
 : (value "short"). A third value, "count", returns the total number of names 
 : that would otherwise be rendered by the use of the cs:names element 
 : (taking into account the effects of et-al abbreviation and editor/translator 
 : collapsing), which allows for advanced sorting.
 : @values long (default), short, count 
 :)
declare variable $GBiblio:form := 'long' ;

(:~
 : sort-separator
 : Sets the delimiter for name-parts that have switched positions as a result 
 : of name-as-sort-order. The default value is ", " ("Doe, John"). As is the 
 : case for name-as-sort-order, this attribute only affects names written in 
 : the latin or Cyrillic alphabets.
 :)
declare variable $GBiblio:sort-separator := ', ' ;

(:~
 : name-as-sort-order
 : Specifies that names should be displayed with the given name following the 
 : family name (e.g. "John Doe" becomes "Doe, John"). The attribute has two 
 : possible values:
 : "first" - attribute only has an effect on the first name of each name variable
 : "all" - attribute has an effect on all names
 :)
declare variable $GBiblio:name-as-sort-order := 'first' ;