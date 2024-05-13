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
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(400)
            make.bottom.equalToSuperview()
        }
    }
}
