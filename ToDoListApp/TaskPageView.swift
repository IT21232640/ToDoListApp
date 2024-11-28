import SwiftUI
import CoreData

struct TaskPageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: true)])
    private var tasks: FetchedResults<Task>

    @State private var newTaskName = ""
    @State private var newTaskDescription = ""
    @State private var newTaskDate = Date()
    @State private var isEditingTask: Task? = nil

    var body: some View {
        VStack {
            // Task Form
            VStack(alignment: .leading) {
                TextField("Task Name", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Task Description", text: $newTaskDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                DatePicker("Due Date", selection: $newTaskDate, displayedComponents: .date)
                    .padding()

                Button(action: {
                    if let task = isEditingTask {
                        updateTask(task)
                    } else {
                        addTask()
                    }
                }) {
                    Text(isEditingTask != nil ? "Update Task" : "Add Task")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }

            // Task List
            List {
                ForEach(tasks) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.taskName ?? "Unnamed Task")
                                .font(.headline)
                            Text(task.taskDescription ?? "No Description")
                                .font(.subheadline)
                            Text("Due Date: \(task.date ?? Date(), formatter: taskDateFormatter)")
                                .font(.footnote)
                        }
                        Spacer()
                        // Edit Button
                        Button(action: {
                            startEditingTask(task)
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 5)

                        // Delete Button
                        Button(action: {
                            deleteTask(task)
                        }) {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Tasks")
        .padding()
    }

    // CRUD Operations
    private func addTask() {
        let newTask = Task(context: viewContext)
        newTask.taskName = newTaskName
        newTask.taskDescription = newTaskDescription
        newTask.date = newTaskDate
        saveContext()
        resetForm()
    }

    private func updateTask(_ task: Task) {
        task.taskName = newTaskName
        task.taskDescription = newTaskDescription
        task.date = newTaskDate
        saveContext()
        resetForm()
    }

    private func deleteTask(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving task: \(error)")
        }
    }

    private func startEditingTask(_ task: Task) {
        isEditingTask = task
        newTaskName = task.taskName ?? ""
        newTaskDescription = task.taskDescription ?? ""
        newTaskDate = task.date ?? Date()
    }

    private func resetForm() {
        newTaskName = ""
        newTaskDescription = ""
        newTaskDate = Date()
        isEditingTask = nil
    }
}

// Date formatter
private let taskDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
