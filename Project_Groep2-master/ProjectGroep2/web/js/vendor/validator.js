/*
 
 jQuery Tools Validator 1.2.3 - HTML5 is here. Now use it.
 
 NO COPYRIGHTS OR LICENSES. DO WHAT YOU LIKE.
 
 http://flowplayer.org/tools/form/validator/
 
 Since: Mar 2010
 Date:    Mon Jun 7 13:43:53 2010 +0000 
 */
(function(d) {
    function v(a, b, c) {
        var k = a.offset().top, f = a.offset().left, l = c.position.split(/,?\s+/), g = l[0];
        l = l[1];
        k -= b.outerHeight() - c.offset[0];
        f += a.outerWidth() + c.offset[1];
        c = b.outerHeight() + a.outerHeight();
        if (g === "center")
            k += c / 2;
        if (g === "bottom")
            k += c;
        a = a.outerWidth();
        if (l === "center")
            f -= (a + b.outerWidth()) / 2;
        if (l === "left")
            f -= a;
        return{top: k, left: f};
    }
    function w(a) {
        function b() {
            return this.getAttribute("type") === a;
        }
        b.key = "[type=" + a + "]";
        return b;
    }
    function s(a, b, c) {
        function k(g, e, j) {
            if (!(!c.grouped && g.length)) {
                var h;
                if (j === false || d.isArray(j)) {
                    h = i.messages[e.key || e] || i.messages["*"];
                    h = h[c.lang] || i.messages["*"].en;
                    (e = h.match(/\$\d/g)) && d.isArray(j) && d.each(e, function(n) {
                        h = h.replace(this, j[n]);
                    });
                } else
                    h = j[c.lang] || j;
                g.push(h);
            }
        }
        var f = this, l = b.add(f);
        a = a.not(":button, :image, :reset, :submit");
        d.extend(f, {getConf: function() {
                return c;
            }, getForm: function() {
                return b;
            }, getInputs: function() {
                return a;
            }, invalidate: function(g, e) {
                if (!e) {
                    var j = [];
                    d.each(g, function(h, n) {
                        h = a.filter("[name=" + h + "]");
                        if (h.length) {
                            h.trigger("OI", [n]);
                            j.push({input: h, messages: [n]});
                        }
                    });
                    g = j;
                    e = d.Event();
                }
                e.type = "onFail";
                l.trigger(e, [g]);
                e.isDefaultPrevented() || q[c.effect][0].call(f, g, e);
                return f;
            }, reset: function(g) {
                g = g || a;
                g.removeClass(c.errorClass).each(function() {
                    var e = d(this).data("msg.el");
                    if (e) {
                        e.remove();
                        d(this).data("msg.el", null);
                    }
                }).unbind(c.errorInputEvent || "");
                return f;
            }, destroy: function() {
                b.unbind(c.formEvent).unbind("reset.V");
                a.unbind(c.inputEvent || "").unbind("change.V");
                return f.reset();
            }, checkValidity: function(g, e) {
                g = g || a;
                g = g.not(":disabled");
                if (!g.length)
                    return true;
                e = e || d.Event();
                e.type = "onBeforeValidate";
                l.trigger(e, [g]);
                if (e.isDefaultPrevented())
                    return e.result;
                var j = [], h = c.errorInputEvent + ".v";
                g.each(function() {
                    var p = [], m = d(this).unbind(h).data("messages", p);
                    d.each(t, function() {
                        var o = this, r = o[0];
                        if (m.filter(r).length) {
                            o = o[1].call(f, m, m.val());
                            if (o !== true) {
                                e.type = "onBeforeFail";
                                l.trigger(e, [m, r]);
                                if (e.isDefaultPrevented())
                                    return false;
                                var u = m.attr(c.messageAttr);
                                if (u) {
                                    p = [u];
                                    return false;
                                } else
                                    k(p, r, o);
                            }
                        }
                    });
                    if (p.length) {
                        j.push({input: m,
                            messages: p});
                        m.trigger("OI", [p]);
                        c.errorInputEvent && m.bind(h, function(o) {
                            f.checkValidity(m, o);
                        });
                    }
                    if (c.singleError && j.length)
                        return false;
                });
                var n = q[c.effect];
                if (!n)
                    throw'Validator: cannot find effect "' + c.effect + '"';
                if (j.length) {
                    f.invalidate(j, e);
                    return false;
                } else {
                    n[1].call(f, g, e);
                    e.type = "onSuccess";
                    l.trigger(e, [g]);
                    g.unbind(h);
                }
                return true;
            }});
        d.each("onBeforeValidate,onBeforeFail,onFail,onSuccess".split(","), function(g, e) {
            d.isFunction(c[e]) && d(f).bind(e, c[e]);
            f[e] = function(j) {
                d(f).bind(e, j);
                return f;
            };
        });
        c.formEvent && b.bind(c.formEvent, function(g) {
            if (!f.checkValidity(null, g))
                return g.preventDefault();
        });
        b.bind("reset.V", function() {
            f.reset();
        });
        a[0] && a[0].validity && a.each(function() {
            this.oninvalid = function() {
                return false;
            };
        });
        if (b[0])
            b[0].checkValidity = f.checkValidity;
        c.inputEvent && a.bind(c.inputEvent, function(g) {
            f.checkValidity(d(this), g);
        });
        a.filter(":checkbox, select").filter("[required]").bind("change.V", function(g) {
            var e = d(this);
            if (this.checked || e.is("select") && d(this).val())
                q[c.effect][1].call(f,
                        e, g);
        });
    }
    d.tools = d.tools || {version: "1.2.3"};
    var x = /\[type=([a-z]+)\]/, y = /^-?[0-9]*(\.[0-9]+)?$/, z = /^([a-z0-9_\.\-\+]+)@([\da-z\.\-]+)\.([a-z\.]{2,6})$/i, A = /^(https?:\/\/)?([\da-z\.\-]+)\.([a-z\.]{2,6})([\/\w \.\-]*)*\/?$/i, i;
    i = d.tools.validator = {conf: {grouped: false, effect: "default", errorClass: "invalid", inputEvent: null, errorInputEvent: "keyup", formEvent: "submit", lang: "en", message: "<div/>", messageAttr: "data-message", messageClass: "error", offset: [0, 0], position: "center right", singleError: false, speed: "normal"},
        messages: {"*": {en: "Please correct this value"}}, localize: function(a, b) {
            d.each(b, function(c, k) {
                i.messages[c] = i.messages[c] || {};
                i.messages[c][a] = k;
            });
        }, localizeFn: function(a, b) {
            i.messages[a] = i.messages[a] || {};
            d.extend(i.messages[a], b);
        }, fn: function(a, b, c) {
            if (d.isFunction(b))
                c = b;
            else {
                if (typeof b === "string")
                    b = {en: b};
                this.messages[a.key || a] = b;
            }
            if (b === x.exec(a))
                a = w(b[1]);
            t.push([a, c]);
        }, addEffect: function(a, b, c) {
            q[a] = [b, c];
        }};
    var t = [], q = {"default": [function(a) {
                var b = this.getConf();
                d.each(a, function(c, k) {
                    c = k.input;
                    c.addClass(b.errorClass);
                    var f = c.data("msg.el");
                    if (!f) {
                        f = d(b.message).addClass(b.messageClass).appendTo(document.body);
                        c.data("msg.el", f);
                    }
                    f.css({visibility: "hidden"}).find("span").remove();
                    d.each(k.messages, function(l, g) {
                        d("<span/>").html(g).appendTo(f);
                    });
                    f.outerWidth() === f.parent().width() && f.add(f.find("p")).css({display: "inline"});
                    k = v(c, f, b);
                    f.css({visibility: "visible", position: "absolute", top: k.top, left: k.left}).fadeIn(b.speed);
                });
            }, function(a) {
                var b = this.getConf();
                a.removeClass(b.errorClass).each(function() {
                    var c =
                            d(this).data("msg.el");
                    c && c.css({visibility: "hidden"});
                });
            }]};
    d.each("email,url,number".split(","), function(a, b) {
        d.expr[":"][b] = function(c) {
            return c.getAttribute("type") === b;
        };
    });
    d.fn.oninvalid = function(a) {
        return this[a ? "bind" : "trigger"]("OI", a);
    };
    i.fn(":email", "Please enter a valid email address", function(a, b) {
        return!b || z.test(b);
    });
    i.fn(":url", "Please enter a valid URL", function(a, b) {
        return!b || A.test(b);
    });
    i.fn(":number", "Please enter a numeric value.", function(a, b) {
        return y.test(b);
    });
    i.fn("[max]", "Please enter a value smaller than $1",
            function(a, b) {
                if (d.tools.dateinput && a.is(":date"))
                    return true;
                a = a.attr("max");
                return parseFloat(b) <= parseFloat(a) ? true : [a];
            });
    i.fn("[min]", "Please enter a value larger than $1", function(a, b) {
        if (d.tools.dateinput && a.is(":date"))
            return true;
        a = a.attr("min");
        return parseFloat(b) >= parseFloat(a) ? true : [a];
    });
    i.fn("[required]", "Please complete this mandatory field.", function(a, b) {
        if (a.is(":checkbox"))
            return a.is(":checked");
        return!!b;
    });
    i.fn("[pattern]", function(a) {
        var b = new RegExp("^" + a.attr("pattern") + "$");
        return b.test(a.val());
    });
    d.fn.validator = function(a) {
        var b = this.data("validator");
        if (b) {
            b.destroy();
            this.removeData("validator");
        }
        a = d.extend(true, {}, i.conf, a);
        if (this.is("form"))
            return this.each(function() {
                var c = d(this);
                b = new s(c.find(":input"), c, a);
                c.data("validator", b);
            });
        else {
            b = new s(this, this.eq(0).closest("form"), a);
            return this.data("validator", b);
        }
    };
})(jQuery);