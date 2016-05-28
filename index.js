var matches = [
  { re: (ctx) => "<b>" + ctx + "</b>", next: ["*", "*"] },
  { re: (ctx) => "<i>" + ctx + "</i>", next: ["_", "_"] },
  { re: (ctx) => "<code>" + ctx + "</code>", next: ["`", "`"] },
  { re: (ctx) => "<a>" + ctx + "</a>", next: ["[", "]", "(", ")"] }
]

var last = (arr) => arr.slice(-1)
var head = (arr) => arr.slice(1)

var recur = (str, stack) => {
  if(!str) return stack;
  
  var deep = stack.deep
  var tmp = {}
  var curr = str[0]
  var matched = matches.filter(n => n.next.some( m => m === curr))
  var target = stack.target
  var lastMatcher = last(target)
  var lasts = lastMatcher.length ? lastMatcher[0].slice(-1)[0] : ""
  console.log(matched, lasts, curr, target)
  
  if(matched.length) {
    if(lasts == curr) {
      //if(target.length === 0) {
      var data = stack[deep].slice(1).join("")
      stack[deep - 1].push(matched[0].re(data))
      //}
      deep = deep - 1
      delete stack[deep + 1]
      curr = ""
      
      //target = target.slice(0, -1)
      lastMatcher.pop()
      console.log("RE", lastMatcher)
      if(!lastMatcher.length) {
        
        target.pop()
      }
    } else {
      deep = deep + 1
      stack[deep] = []
      target.push(head(matched[0].next))
    }
  }
  
  tmp[deep] = [].concat(stack[deep]).concat(curr)
  var out = Object.assign({}, 
                          stack,
                          { deep: deep },
                          { target: target },
                           tmp)

  console.log(JSON.stringify(out))
  return recur(head(str), out)
}

console.log(
  recur("23333 *w_ha_t*'s `this` [test](http://www.baidu.com)", { deep: 0, target: [], "0": [] })[0].join('')
)
