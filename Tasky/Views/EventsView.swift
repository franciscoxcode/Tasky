//
//  EventsView.swift
//  Tasky
//
//  Created by Francisco Jean on 02/10/25.
//

import SwiftUI

struct EventsView: View {
    var body: some View {
        ProjectsBar(projects: SampleData.sampleProjects, section: .events)
    }
}
