func Tree() {
    let Today = Calendar.current.isDateInWeekend(Date())
    

    let Time = Calendar.current
    let currentTime = Date()
    let rush_begin = Time.date(bySettingHour: 7, minute: 0, second: 0, of: currentTime)!
    

    let rush_end = Time.date(bySettingHour: 9, minute: 30, second: 0, of: currentTime)!
    

    let rushHour = false
    if currentTime >= rush_begin && currentTime <= rush_end {
        let rushHour = true
    } else {
        let rushHour = false
    }
    

let components = ["Weekend?", "Rush Hours?"]
let examples = [

    [true, true],
    [true, false],
    [false, true],
    [false, false]
    


]

let stopLikelyhood = [
    "Route 11",
    "Route 22",
    "Route 41",
    "Equal Distribution"
]

let decisionTree = GKDecisionTree(examples: examples as NSArray as! [[NSObjectProtocol]],
    actions: stopLikelyhood as NSArray as! [NSObjectProtocol],
    attributes: components as NSArray as! [NSObjectProtocol])

    let check = [
        "Weekend?": Today as NSObjectProtocol,
        "Rush Hours?": rushHour as NSObjectProtocol
    ]

let decision = decisionTree.findAction(forAnswers: check)

    print(decision ?? "null" as Any)
}
