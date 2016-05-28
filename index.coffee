md = require "markdown"
markdown = md.markdown

test1 = """
### 123 {#iddd}

ha**aaa**ha_aa_cccccc[c](http://www.baidu.com)ccdddddddd
asd~fasdf~asdfopqwie[ttt]()
asdfpoiq[23333]()

[baidu]()

23321asdlj,zmnxvciopwqerkljnlkasdf
asdfipowqerpoi;lajs ldkfj

[baidu]: http://www.baidu.com

wow`fuckit`wwwwwwwwww![233](img/233)wwww

```js
function() {
  console.log("23333")
}
```

| name | age | page |
| ---- | --= | -+-= |
| mama | 123 | 111  |
| baba | 456 | 222  |

* asdasd
* 123123
  * lii
+ 123
- aspipqwe
1. qwe
2. 23543245

## header 2
axx

`456asd`ad

> 23333 **w_h_at**'s `this`
"""

###
ha**aaa**ha_aa_cccccc[c](http://www.baidu.com)ccdddddddd
asd~fasdf~asdfopqwie[ttt]()
asdfpoiq[23333]()

[baidu]()

23321asdlj,zmnxvciopwqerkljnlkasdf
asdfipowqerpoi;lajs ldkfj

[baidu]: http://www.baidu.com

wow`fuckit`wwwwwwwwww![233](img/233)wwww

```js
function() {
  console.log("23333")
}
```

| name | age | page |
| ---- | --= | -+-= |
| mama | 123 | 111  |
| baba | 456 | 222  |

* asdasd
* 123123
  * lii
+ 123
- aspipqwe
1. qwe
2. 23543245

## header 2
axx

`456asd`ad

> 23333 what's `fuck`
###

###
helps.
###
isEmpty = (arr) -> arr.length is 0
eof = (arr) -> arr[1] is undefined

###
cc
fuse
###

cc_h = (box) -> box.replace /(#+)\s*([^]*)/, (m, a, b) -> "<h#{a.length}>#{b}<h#{a.length}>"
cc_bq = (box) -> box.replace />\s*([^]*)/, "<blockquoute>$1</blockquoute>"
cc_a = (box) -> "" #box
cc_tb = (box) -> "</table>#{box}</table>"
cc_pre = (box) -> "</pre>#{box}</pre>"
cc_li = (box) -> "</ul>#{box}</ul>"
cc_def = (box) -> "<p>#{box}</p>"

m_bs = [
  re: /^\#/, cc: cc_h
,  
  re: /^\>/, cc: cc_bq
,  
  re: /^\[/, cc: cc_a
,  
  re: /^\|/, cc: cc_tb
,          
  re: /^\`{3}/, cc: cc_pre
,
  re: /^[\*|\+|\-]/, cc: cc_li
]


# lifetime: match(yes) -> fetch(no)
# matched -|> content: "<b>aaa", isDone: false, next: 1

cc_fb = (ctx) -> ctx
cc_fi = (ctx) -> ctx

m_is = [
  re: /\*/, f: "b", cc: cc_fb, set: ["*", "*"]
,  
  re: /\_/, f: "i", cc: cc_fi, set: ["_", "_"]
,
  re: /\[/, f: "a", cc: cc_ia, set: ["[", "]", "(", ")"]
]



m_block = (box, cc) ->
  cmp = box.join ''
  out = unless isEmpty cc then cc[0].cc cmp else cc_def cmp
  console.log "-----------------"
  console.log "box:", out
  console.log "~~~~~~~~~~~~~~~~~\n\n"
  out


parser = (md, box, of_b, tb, f_tb, sk_ti, do_ti, out) ->
  return out if isEmpty md
  
  fst = md[0]
  tb.push fst if f_tb and not /\s/.test fst
  box.push fst
  
  of_b = of_b + 1

  # split block content
  iseof = eof md
  isblock = fst is "\n" and md[1] is "\n"
  if iseof or isblock
    out.push m_block box, m_bs.filter (n) -> n.re.test tb
    box = []
    of_b = 0
    tb = []
    sk_ti = []
    do_ti = []
    f_tb = yes
    
  # simple block
  if fst is " " or tb.length is 3
    f_tb = no

  # mark inline
  mi = m_is.filter (n) -> n.re.test fst
  unless isEmpty mi
    fl = mi[0].f
    ma = do sk_ti.pop
    pu = -> sk_ti.push ty: fl, idx: of_b
    if ma is undefined
      do pu
    else if ma.ty is fl and of_b - ma.idx > 1
      do_ti.push ty: fl, idx: [ma.idx, of_b]
    else
      sk_ti.push ma
      do pu
    
  
  
  #console.log fst, tb, f_tb, not /\s/.test fst
  #console.log (eof md), (fst is "\n"), (md[1] is "\n")
  console.log of_b, sk_ti, do_ti
  mds = md.slice 1
  parser mds, box, of_b, tb, f_tb, sk_ti, do_ti, out




# test
console.time("test1")
parser test1, [], 0, [], yes, [], [], []
console.timeEnd("test1")










# test
###
console.time("test1")
markdown.toHTML test1
console.timeEnd("test1")
###

console.time("test2")
markdown.toHTML test1
console.timeEnd("test2")

