import Foundation

public extension String {
    func matches(for regex: String) -> [String] {

        let text = self

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(
                in: text,
                range: NSRange(text.startIndex..., in: text)
            )
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch {
            return []
        }
    }
}
