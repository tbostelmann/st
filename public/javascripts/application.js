// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var i=0;
var l;
var t;
var successStories;

var i2=0;
var l2;
var t2;
var featuredDonors;

var i3 = 0;
var t3;
var l3;
var partnerList;

var i4 = 0;
var t4;
var l4;
var quoteList;

window.onload=function iterate_fade_inout() {
    successStories = document.getElementsByClassName('success-story');
    l = successStories.length;

    featuredDonors = document.getElementsByClassName('featured-donor');
    l2 = featuredDonors.length;

    partnerList = document.getElementsByClassName('partner-list');
    l3 = partnerList.length;

    quoteList = document.getElementsByClassName('take-action-quote');
    l4 = quoteList.length;

    if (l > 0) {fade_inout();}
    if (l2 > 0) {fd_fade_inout();}
    if (l3 > 0) {pl_fade_inout();}
    if (l4 > 0) {quote_fade_inout();}
}

function fade_inout() {
    new Effect.Fade('fadeOn');
    successStories[(i % l)].id = ''
    i++;
    successStories[(i % l)].id = 'fadeOn';
    new Effect.Appear('fadeOn', {queue: 'end'});
    t = setTimeout("fade_inout()",15000);
}

function fd_fade_inout() {
    new Effect.Fade('fdDisplay', {queue: {scope: 'one'}});
    featuredDonors[(i2 % l2)].id = ''
    i2++;
    featuredDonors[(i2 % l2)].id = 'fdDisplay';
    new Effect.Appear('fdDisplay', {queue: {scope: 'one', position: 'end'}});
    t2 = setTimeout("fd_fade_inout()",15000);
}

function pl_fade_inout() {
    new Effect.Fade('plFadeOn', {queue: {scope: 'two'}})
    partnerList[(i3 % l3)].id = ''
    i3++;
    partnerList[(i3 % l3)].id = 'plFadeOn'
    new Effect.Appear('plFadeOn', {queue: {scope: 'two', position: 'end'}})
    t3 = setTimeout("pl_fade_inout()",10000);
}

function quote_fade_inout() {
    new Effect.Fade('quoteFadeOn')
    quoteList[(i4 % l4)].id = ''
    i4++;
    quoteList[(i4 % l4)].id = 'quoteFadeOn'
    new Effect.Appear('quoteFadeOn', {queue: 'end'})
    t4 = setTimeout("quote_fade_inout()",10000);
}
