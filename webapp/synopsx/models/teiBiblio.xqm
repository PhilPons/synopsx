xquery version '3.0' ;
module namespace synopsx.models.teiBiblio = 'synopsx.models.teiBiblio' ;

(:~
 : Simple description of a module in RESTXQ
 : @author Synopsx
 : @date 2014-12-10
 : @version 1.0
 : @see https://github.com/ahn-ens-lyon/synopsx
:)

import module namespace G = "synopsx.globals" at '../globals.xqm'; (: import globals variables :)
import module namespace functx = "http://www.functx.com" ;

declare default function namespace 'synopsx.models.teiBiblio' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0';

declare variable $synopsx.models.teiBiblio:separator := '. ' ;
declare variable $synopsx.models.teiBiblio:nameSeparator := '&#160;; ' ;


(:~
 : This function brings back a list of works
 :)
declare function listWorks() {
  let $options := ''
  let $texts := db:open($G:DBNAME)
  let $lang := 'fr'
  let $meta := {
    'title' : 'Liste d’articles', 
    'author' : '',
    'copyright'  : '',
    'description' : '',
    'keywords' : ''
    }
  let $content as map(*) := map:merge(
    for $node in db:open('gdp')//tei:listBibl
    return map:entry( fn:generate-id($node), getWork($node, $options) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


(:~
 : This function lists works in the DB
 : @todo select only works as for FRBR
 :)
declare function getWork($item as element(), $options) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : 'Listes des œuvres',
    'work' : dispatch($item, $options)
  }
};

(:~
 : This function dispatches the treatment of the XML document
 :)
declare function dispatch($node as node()*, $options) as item()* {
  typeswitch($node)
    case text() return $node
    case element(tei:listBibl) return listBibl($node, $options)
    case element(tei:biblStruct) | element(tei:bibl) return biblItem($node, $options)
    case element(tei:analytic) return getAnalytic($node, $options)
    case element(tei:monogr) return getMonogr($node, $options)
    (: case element(tei:author) return getResponsability($node, $options) :)
    (: case element(tei:editor) return getResponsability($node, $options) :)
    case element(tei:persName) return persName($node, $options)
    case element(tei:head) return '' (: bof :)
    default return passthru($node, $options)
};

(:~
 : This function pass through child nodes (xsl:apply-templates)
 :)
declare function passthru($nodes as node()*, $options) as item()* {
  for $node in $nodes/node()
  return dispatch($node, $options)
};

declare function listBibl($node, $options) {
  <ul>{passthru($node, $options)}</ul>
};

declare function biblItem($node, $options) {
   <li>{ passthru($node, $options) }</li>
};


(:~
 : This function treats tei:analytic
 : @toto group author and editor to treat distinctly
 :)
declare function getAnalytic($node, $options) {
  getResponsabilities($node, $options), 
  getTitle($node, $options)
};

(:~
 : This function treats tei:monogr
 :)
declare function getMonogr($node, $options) {
  getResponsabilities($node, $options), 
  getTitle($node, $options),
  getEdition($node, $options)
};

(:~
 : This function returns title in an html element
 : different html element whereas it is an analytic or a monographic title
 : @todo do we keep html serialisation here ?
 :)
declare function getTitle($node, $options) {
  for $title in $node/tei:title
  return if ($title[@level='a'])
    then <span class="title">« {$title} »</span>
    else <em class="title">{$title}</em>
};

declare function getEdition($node, $options) {
  passthru($node, $options)
};


(:~
 : This function get responsabilities
 : @toto group authors and editors to treat them distinctly
 : @toto "éd." vs "éds."
 :)
declare function getResponsabilities($node, $options) {
  for $responsability at $count in $node/tei:author | $node/tei:editor
  let $nbResponsabilities := fn:count($node/tei:author | $node/tei:editor)
  return if ($count = $nbResponsabilities) then (getResponsability($responsability, $options), '.')
    else (getResponsability($responsability, $options), ' ; ')
};

(:~
 : si le dernier auteur mettre un séparateur à la fin.
 :
 :)
declare function getResponsability($node, $options) {
  if ($node/tei:forename or $node/tei:surname) 
  then getName($node, $options) 
  else passthru($node, $options)
};

declare function persName($node, $options) {
    getName($node, $options)
};

(:~
 : This fonction concatenate surname and forname with a ', '
 : @todo cases with only one element
 :)
declare function getName($node, $options) {
  if ($node/tei:forename and $node/tei:surname)
  then ($node/tei:forename || ', ', <span class="smallcaps">{$node/tei:surname/text()}</span>)
  else if ($node/tei:surname) then <span class="smallcaps">{$node/tei:surname/text()}</span>
  else if ($node/tei:forename) then $node/tei:surname/text()
  else passthru($node, $options)
};

declare %restxq:path('/biblio') 
        %output:method("xml")
function biblio() {
  <xml> { let $options := ''
  for $node in db:open('gdp')//tei:listBibl
  return dispatch($node, $options) }</xml>
};





















