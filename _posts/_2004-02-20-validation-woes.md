---
layout: post
title: "validation woes"
author: Waylan Limberg
categories: "html"
summary: "Wow. I just checked a page I have been working on (not this one) for validation as xhtml 1.1 strict and received 154 errors. Ouch! I'm not that bad, am I? As it turns out, this particular page links to 4 different Yahoo Maps. When creating the links, I went to yahoo, found the map views I wanted and cut and pasted the links they provided. All 154 errors came from those 4 lines of code. Thank you Yahoo!"
---

Wow. I just checked a page I have been working on (not this one) for validation as xhtml 1.1 strict and received 154 errors. Ouch! I'm not that bad, am I? As it turns out, this particular page links to 4 different Yahoo Maps. When creating the links, I went to yahoo, found the map views I wanted and cut and pasted the links they provided. All 154 errors came from those 4 lines of code. Thank you Yahoo!

On a separate note, I also checked this page for validation for the very first time. I know, I know, I meant to do it before but just never bothered. Anyway, I only had three minor errors. As it turns out I forgot quotes around an ID. I also failed to include the type attribute in the style tag included in the head of the document. A small oversight, as I intend to move all of the css to the external style sheet when I finalize the design, which, by the way, is referenced correctly. Apparently the third error is for having a pre tag inside a p tag. I guess I missed that one.

Not bad. One typo, one error because the design is not complete and only one real error. I can live with that. Ok, I can't live with the errors remaining (I fixed them while posting this), but I am quite satisfied with the results, considering I typed all the code from hand. When you consider that the first document I mentioned only contained errors with code I cut and pasted, I think it's fairly safe to say I, for the most part, know what I am doing (that is, when writing my own code - even in xhtml 1.1 strict). How valid is the css? Well, that's another thing entirely.

<strong>update:</strong>

Once the xhtml validated, I validated the css as well as for Section 508 Accessibility and it all passed in flying colors. Now to do the same with the maps page. Arg!

Note, I have included the correct links at the bottom of this page, so validate for your own <del>pleasure</del>, er benefit.