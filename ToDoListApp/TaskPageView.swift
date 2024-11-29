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
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                Text("Manage Your Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Task Form
                VStack(spacing: 15) {
                    TextField("Task Name", text: $newTaskName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)

                    TextField("Task Description", text: $newTaskDescription)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)

                    DatePicker("Due Date", selection: $newTaskDate, displayedComponents: .date)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.horizontal)

                    Button(action: {
                        if let task = isEditingTask {
                            updateTask(task)
                        } else {
                            addTask()
                        }
                    }) {
                        Text(isEditingTask != nil ? "Update Task" : "Add Task")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isEditingTask != nil ? Color.green : Color.blue)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
                
                // Task List
                List {
                    ForEach(tasks) { task in
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(task.taskName ?? "Unnamed Task")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(task.taskDescription ?? "No Description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Due: \(task.date ?? Date(), formatter: taskDateFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                            
                            // Edit Button
                            Button(action: {
                                startEditingTask(task)
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.green)
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
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(false) // Ensure default back button
        .navigationTitle("Tasks") // Use navigation title
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
