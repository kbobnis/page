---
layout: post
title:  "Błędy gita"
date:   2021-05-30 09:11:26 +0100
categories: development
---
 
 
<!-- wp:paragraph -->
<p>Błąd:</p>
<!-- /wp:paragraph -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p>error: RPC failed; curl 92 HTTP/2 stream 0 was not closed cleanly: CANCEL (err 8)<br>send-pack: unexpected disconnect while reading sideband packet</p></blockquote>
<!-- /wp:quote -->

<!-- wp:paragraph -->
<p>dodałem:</p>
<!-- /wp:paragraph -->

<!-- wp:quote -->
<blockquote class="wp-block-quote"><p>git config http.postBuffer 524288000 </p></blockquote>
<!-- /wp:quote -->

<!-- wp:paragraph -->
<p>pomogło.</p>
<!-- /wp:paragraph -->
