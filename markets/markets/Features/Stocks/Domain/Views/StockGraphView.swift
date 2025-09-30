import UIKit

final class StockGraphView: UIView {
    private let margin: CGFloat = 8

    init() {
        super.init(frame: .zero)
        setupViewAttributes()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewAttributes() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
    }
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func draw(data: [StockPoint]) {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard data.count > 1 else { return }

        let path = createLinePath(data: data)
        let shapeLayer = createShapeLayer(path: path)
        let gradientLayer = createGradientLayer(path: path, dataCount: data.count)

        layer.insertSublayer(gradientLayer, below: shapeLayer)
        layer.addSublayer(shapeLayer)
        addCirclePoints(data: data)
    }

    private func createLinePath(data: [StockPoint]) -> UIBezierPath {
        let maxClose = data.map { $0.close }.max() ?? 1
        let minClose = data.map { $0.close }.min() ?? 0
        let height = bounds.height - 2 * margin
        let width = bounds.width
        let stepX = (width - 2 * margin) / CGFloat(data.count - 1)

        func yPosition(_ value: Double) -> CGFloat {
            guard maxClose != minClose else { return bounds.height / 2 }
            let ratio = (value - minClose) / (maxClose - minClose)
            return bounds.height - margin - CGFloat(ratio) * height
        }

        let path = UIBezierPath()
        for (index, point) in data.enumerated() {
            let x = margin + CGFloat(index) * stepX
            let y = yPosition(point.close)
            index == 0 ? path.move(to: CGPoint(x: x, y: y)) : path.addLine(to: CGPoint(x: x, y: y))
        }
        return path
    }

    private func createShapeLayer(path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeEnd = 0

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        shapeLayer.add(animation, forKey: "line")
        shapeLayer.strokeEnd = 1
        return shapeLayer
    }

    private func createGradientLayer(path: UIBezierPath, dataCount: Int) -> CAGradientLayer {
        let height = bounds.height
        let width = bounds.width
        let stepX = (width - 2 * margin) / CGFloat(dataCount - 1)

        let fillPath = UIBezierPath(cgPath: path.cgPath)
        fillPath.addLine(to: CGPoint(x: margin + stepX * CGFloat(dataCount - 1), y: height - margin))
        fillPath.addLine(to: CGPoint(x: margin, y: height - margin))
        fillPath.close()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        let maskLayer = CAShapeLayer()
        maskLayer.path = fillPath.cgPath
        gradientLayer.mask = maskLayer

        return gradientLayer
    }

    private func addCirclePoints(data: [StockPoint]) {
        let maxClose = data.map { $0.close }.max() ?? 1
        let minClose = data.map { $0.close }.min() ?? 0
        let height = bounds.height - 2 * margin
        let width = bounds.width
        let stepX = (width - 2 * margin) / CGFloat(data.count - 1)

        func yPosition(_ value: Double) -> CGFloat {
            guard maxClose != minClose else { return bounds.height / 2 }
            let ratio = (value - minClose) / (maxClose - minClose)
            return bounds.height - margin - CGFloat(ratio) * height
        }

        for (index, point) in data.enumerated() {
            let x = margin + CGFloat(index) * stepX
            let y = yPosition(point.close)

            let circlePath = UIBezierPath(ovalIn: CGRect(x: x - 2.5, y: y - 2.5, width: 5, height: 5))
            let circleLayer = CAShapeLayer()
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = UIColor.systemBlue.cgColor
            layer.addSublayer(circleLayer)
        }
    }
}
