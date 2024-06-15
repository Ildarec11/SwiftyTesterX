import Cocoa

final class DraggableFileView: NSView {

    var filePath: String
    var fileContent: String

    private let imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()

    private let label: NSTextField = {
        let label = NSTextField()
        label.isEditable = false
        label.isBezeled = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.alignment = .left
        return label
    }()

    init(frame frameRect: NSRect, filePath: String, fileContent: String) {
        self.filePath = filePath
        self.fileContent = fileContent
        super.init(frame: frameRect)
        registerForDraggedTypes([.fileURL])
        setupSubviews()
        setupConstraints()
        imageView.image = NSImage(named: "json")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(label)
        label.stringValue = filePath
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func sanitizeFileName(_ fileName: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>:")
        let prefixed = fileName.components(separatedBy: invalidCharacters).joined(separator: "_")
        return prefixed.replacing("___", with: "_")
    }
}

extension DraggableFileView: NSDraggingSource {
    override func mouseDown(with event: NSEvent) {
        let pasteboardItem = NSPasteboardItem()
        
        // Correcting the file path for drag operation to be a temporary JSON file
        let fileName = sanitizeFileName(filePath).appending(".json")
        let tempDirectory = NSTemporaryDirectory()
        let tempFilePath = (tempDirectory as NSString).appendingPathComponent(fileName)
        
        do {
            // try fileContent.write(toFile: tempFilePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing temporary file: \(error)")
            return
        }

        pasteboardItem.setString(tempFilePath, forType: .fileURL)
        
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        draggingItem.setDraggingFrame(self.bounds, contents: imageView.image)

        let draggingSession = beginDraggingSession(with: [draggingItem], event: event, source: self)
        draggingSession.animatesToStartingPositionsOnCancelOrFail = false
        draggingSession.draggingFormation = .none
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }

    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return .copy
    }

    func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        let fileManager = FileManager.default
        let desktopPath = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let sanitizedFileName = sanitizeFileName(filePath) + ".json"
        let fileURL = desktopPath.appendingPathComponent(sanitizedFileName)

        do {
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File written to: \(fileURL.path)")
        } catch {
            print("Error writing file: \(error)")
        }
    }
}
