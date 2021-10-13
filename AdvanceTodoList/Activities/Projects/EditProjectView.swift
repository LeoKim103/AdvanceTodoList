//
//  EditProjectView.swift
//  AdvanceTodoList
//
//  Created by Leo Kim on 12/10/2021.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDeletionConfirm = false

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField(NSLocalizedString("Project name", comment: ""), text: $title.onChange(update))
                TextField(NSLocalizedString("Description of this project", comment: ""), text: $detail.onChange(update))
            }

            Section(header: Text("Custom project Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }
            // swiftlint:disable:next line_length
            Section(header: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project") {
                    project.closed.toggle()
                    update()
                }

                Button("Delete this project") {
                    showingDeletionConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeletionConfirm) {
            Alert(title: Text("Delete project?"), // swiftlint:disable:next line_length
                  message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
                  primaryButton: .default(Text("Delete"), action: delete),
                  secondaryButton: .cancel())
        }

    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environmentObject(DataController())
    }
}

extension EditProjectView {

    private func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    private func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    private func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}
