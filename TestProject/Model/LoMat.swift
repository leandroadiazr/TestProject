//
//  LoMATWorkflow.swift
//  TableTest (iOS)
//
//  Created by Greg Fisch on 2/16/22.
//

import SwiftUI

struct LoMAT {
    typealias PONumber = Int
    typealias WorkflowId = String
    typealias MilestoneId = Int
    typealias QuestionId = Int

    struct Workflow: Codable {
        let id: WorkflowId
        let workflowType: String
        let applicableTrailerTypeIds: [Int]?
        let poNumber: PONumber?
        let stopId: Int?
        let stopType: String?
        var stopMilestone: [StopMilestone]
    }

    struct StopMilestone: Codable {
        let id: MilestoneId
        let stopMilestoneType: String
        var completed: Bool
        var eventPublished: Bool
        var questions: [Question]
        var driverLocation: DriverLocation?
    }
        
    struct DriverLocation: Codable {
        var state: String?
        var city: String?
        var postalCode: String?
    }

    struct Question: Codable {
        let id: QuestionId
        let descendants: [WorkFlowDescendant]?
        let questionName: String?
        let questionType: String
        let style: String?
        let header: String?
        let questionText: String?
        let mobileDisplayData: String?
        var selectedAnswer: String?
        var uiState: String?
        let availableResponses: [AvailableResponse]?
    }

    struct WorkFlowDescendant: Codable {
        let descendantId: Int?
        let condition: String?
    }

    struct AvailableResponse: Codable {
        let display: String?
        let value: String?
    }

    struct AnswerIndex {
        let milestoneId: MilestoneId
        let questionId: QuestionId
    }
}

// MARK: - Convenience initializers
extension LoMAT.Workflow {
    init?(data: Data) {
        guard let workflow = try? JSONDecoder().decode(LoMAT.Workflow.self, from: data) else { return nil }
        self = workflow
    }

    init?(fromJsonFile name: String){
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json") else { return nil }
        guard let jsonData = try? String(contentsOfFile: bundlePath).data(using: .utf8) else { return nil }
        self.init(data: jsonData)
    }
}

// MARK: - JSON Methods
extension LoMAT.Workflow {
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Mutating Functions
extension LoMAT.Workflow {
    mutating func updateAnswer(_ answer: String, answerIndex: LoMAT.AnswerIndex) {
        for (milestoneIndex, var milestone) in self.stopMilestone.enumerated() where milestone.id == answerIndex.milestoneId {

            for (questionIndex, question) in milestone.questions.enumerated() where question.id == answerIndex.questionId {
                milestone.questions[questionIndex].selectedAnswer = answer
                self.stopMilestone[milestoneIndex] = milestone
                return
            }
        }
    }

    mutating func updateDriverLocation(atMilestone stopMilestoneId: LoMAT.MilestoneId) {
        // Add Location Code here
        for (milestoneIndex, var milestone) in self.stopMilestone.enumerated() where milestone.id == stopMilestoneId {
            // Values hard-coded for now.  Will use app location objects
            milestone.driverLocation?.city = "Charlotte"
            milestone.driverLocation?.state = "NC"
            milestone.driverLocation?.postalCode = "28269"

            self.stopMilestone[milestoneIndex] = milestone
            break
        }
    }

    mutating func updateCompleted(atMilestone milestoneId: LoMAT.MilestoneId) {
        for (milestoneIndex, var milestone) in self.stopMilestone.enumerated() where milestone.id == milestoneId {
            milestone.completed = true
            self.stopMilestone[milestoneIndex] = milestone
        }
    }
}


// MARK: - Hashable Conformances for SwifTUI ForEach
extension LoMAT.StopMilestone: Hashable  {
    static func == (lhs: LoMAT.StopMilestone, rhs: LoMAT.StopMilestone) -> Bool {
        return lhs.hashValue == rhs.hashValue // this can be replace by the new id and drop the hash entirely
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(stopMilestoneType)  // This needs to be enhanced as it isnt unique enough
    }
}

extension LoMAT.Question: Hashable {
    static func == (lhs: LoMAT.Question, rhs: LoMAT.Question) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // This needs to be enhanced as it isnt unique enough
    }
}
