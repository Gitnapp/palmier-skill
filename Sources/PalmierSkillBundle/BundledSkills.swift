import Foundation

public enum PalmierSkillBundle {
    public static var skillsDirectory: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Skills", isDirectory: true)
    }
}
