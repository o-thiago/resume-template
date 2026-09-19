#import "../../template.typ": resume

#let data-file = sys.inputs.at("data", default: "../../data/cv.yaml")
#let raw-data = yaml(data-file)
#let cv = raw-data.en

#resume(cv)
