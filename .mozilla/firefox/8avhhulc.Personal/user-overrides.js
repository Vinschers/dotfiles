/* MY OVERRIDES */
user_pref("_user.js.parrot", "overrides section syntax error");

/* Mental Outlaw recomendations */
user_pref("geo.enabled", false);
//user_pref("network.http.sendRefererHeader", 0);

/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("places.history.enabled", true); // 0862 required if you had it set as false
user_pref("browser.sessionstore.privacy_level", 0); // 1003 [to restore cookies/formdata if not sanitized]
  // user_pref("network.cookie.lifetimePolicy", 0); // 2801 [DON'T: add cookie + site data exceptions instead]
user_pref("privacy.clearOnShutdown.history", false); // 2811
  // user_pref("privacy.clearOnShutdown.cookies", false); // 2811 optional: default false arkenfox v94
  // user_pref("privacy.clearOnShutdown.formdata", false); // 2811 optional
user_pref("privacy.cpd.history", false); // 2812 to match when you use Ctrl-Shift-Del
  // user_pref("privacy.cpd.cookies", false); // 2812 optional: default false arkenfox v94
  // user_pref("privacy.cpd.formdata", false); // 2812 optional

/* Custom settings */
user_pref("browser.startup.homepage", "https://searx.xyz");
user_pref("keyword.enabled", true);
user_pref("privacy.resistFingerprinting", false);
user_pref("media.autoplay.blocking_policy", 0); // Moe.listen

user_pref("_user.js.parrot", "overrides section successful");
