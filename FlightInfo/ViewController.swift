//
//  ViewController.swift
//  FlightInfo
//
//  Created by Cong Le on 12/28/20.
//

import UIKit

enum AnimationDirection: Int {
  case positive = 1
  case negative = -1
}

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
  
  lazy var bgImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var summaryIcon: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "icon-blue-arrow.png")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var summaryString: UILabel = {
    let label = UILabel()
    label.text = "Flight Summary"
    label.textColor = .white
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  var navStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 20
    stackView.distribution = .equalCentering
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  lazy var flightLabel: UILabel = {
    let label = UILabel()
    label.text = "Flight"
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 19.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var gateLabel: UILabel = {
    let label = UILabel()
    label.text = "Gate"
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 19.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var flightNr: UILabel = {
    let label = UILabel()
    label.text = "Fl. Nr."
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 27.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var gateNr: UILabel = {
    let label = UILabel()
    label.text = "Gate. Nr."
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 27.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var departingFrom: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 254/255, green: 214/255, blue: 146/255, alpha: 1.0)
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 43.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var arrivingTo: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 254/255, green: 214/255, blue: 146/255, alpha: 1.0)
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 43.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var planeImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "plane.png")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  lazy var flightStatus: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(red: 218/255, green: 76/255, blue: 6/255, alpha: 1.0)
    label.textAlignment = .center
    label.font = UIFont(name: "Helvetica Neue Condensed Bold", size: 30.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var statusBanner: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "banner.png")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  var snowView = SnowView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    addSnowEffectView()
    
    // start rotating the flights
    changeFlight(to: londonToParis)
  }
  
  func changeFlight(to data: FlightData, animated: Bool = false) {
    // populate the UI with the next flight's data
    summaryString.text = data.summaryString
    
    /// If aniamted, apply`fade` effect for `flightNr`, `gateNr`, `departingFrom`, and `arrivingTo`
    /// Otherwise, perfrom binding data 
    if animated {
      
      fade(imageView: bgImageView,
           toImage: UIImage(named: data.weatherImageName) ?? UIImage(),
           showEffects: data.showWeatherEffects)
      
      let direction: AnimationDirection = data.isTakingOff ? .positive : .negative
      
      performCubeTransition(with: data, with: direction)
      performMoveLabelEffect(with: data, with: direction)
      
      
      planeDepart()
      
      summaryStringSwitch(to: data.summaryString)
    } else {
      performBindingData(for: data)
    }
    
    /// oscillate the flights with 3 seconds delay between each flight
    delay(seconds: 3.0) {
      self.changeFlight(
        to: data.isTakingOff ? parisToRome : londonToParis,
        animated: true
      )
    }
  }
}

// MARK: - Animating methods
extension ViewController {
  /// Apply `cubeTransition` for `flightNr`, `gateNr`, and `flightStatus`
  func performCubeTransition(with flightData: FlightData, with direction: AnimationDirection) {
    cubeTransition(label: flightNr, text: flightData.flightNr, direction: direction)
    cubeTransition(label: gateNr, text: flightData.gateNr, direction: direction)
    cubeTransition(label: flightStatus, text: flightData.flightStatus, direction: direction)
  }
  
  /// Apply `moveLabel` effect for `departingFrom` and `arrivingTo`
  func performMoveLabelEffect(with flightData: FlightData, with direction: AnimationDirection) {
    
    let offsetDeparting = CGPoint(
      x: CGFloat(direction.rawValue * 80),
      y: 0.0
    )
    
    moveLabel(label: departingFrom, text: flightData.departingFrom, offset: offsetDeparting)
    
    let offsetArriving = CGPoint(
      x: 0.0,
      y: CGFloat(direction.rawValue * 50)
    )
    
    moveLabel(label: arrivingTo, text: flightData.arrivingTo, offset: offsetArriving)
  }
  
  func performBindingData(for flightData: FlightData) {
    bgImageView.image = UIImage(named: flightData.weatherImageName)
    snowView.isHidden = !flightData.showWeatherEffects
    
    flightNr.text = flightData.flightNr
    gateNr.text = flightData.gateNr
    
    departingFrom.text = flightData.departingFrom
    arrivingTo.text = flightData.arrivingTo
    
    flightStatus.text = flightData.flightStatus
  }
  
  //add the snow effect layer
  func addSnowEffectView() {
    snowView = SnowView(frame: CGRect(x: -150, y: -100, width: 300, height: 50))
    let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
    snowClipView.clipsToBounds = true
    snowClipView.addSubview(snowView)
    view.addSubview(snowClipView)
  }
  
  /// Fading effect
  /// `imageView`: the image view is about to fade out
  /// `toImage`: the new image need to display at the end of the animation
  /// `showEffects`: Hide/Show the snowfall effect
  func fade(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
    
    UIView.transition(
      with: imageView,
      duration: 1.0,
      options: .transitionCrossDissolve,
      animations: {
        imageView.image = toImage
      },
      completion: nil
    )
    
    UIView.animate(
      withDuration: 1.0,
      delay: 0.0,
      options: .curveEaseOut,
      animations: {
        self.snowView.alpha = showEffects ? 1 : 0
      },
      completion: nil
    )
  }
  
  /// The auxiliary label will contain the new text through cude transition
  /// `label`: Label will animate
  /// `text`: The new text to display on the label
  /// `direction`: location from where we animate the new text label, either the top or the bottom of the view
  func cubeTransition(label: UILabel, text: String, direction: AnimationDirection) {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.text = text
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = label.backgroundColor
    
    /// Calculate the vertical offset for the auxiliary label
    /// The raw value of direction is either 1 or -1, which gives you the proper vertical offset to position the temporary label.
    let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height / 2.0
    
    /// adjust the transform of the auxiliary label to create a faux-perspective effect
    auxLabel.transform = CGAffineTransform(translationX: 0.0, y: auxLabelOffset)
      .scaledBy(x: 1.0, y: 0.1)
    
    label.superview?.addSubview(auxLabel)
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0.0,
      options: .curveEaseOut,
      animations: {
        /// reset the transform of auxLabel
        /// this makes the new text grow in height and positions it exactly on top of the old one.
        auxLabel.transform = .identity
        label.transform = CGAffineTransform(translationX: 0.0, y: -auxLabelOffset)
          .scaledBy(x: 1.0, y: 0.1)
      },
      completion: { _ in
        label.text = auxLabel.text
        label.transform = .identity
        
        auxLabel.removeFromSuperview()
      }
    )
  }
  
  /// Ghost like effect for label
  /// `label`: Label will animate
  /// `text`: The new text to display on the label
  /// `offset`: The arbitrary offset you’ll use to animate the auxiliary label.
  func moveLabel(label: UILabel, text: String, offset: CGPoint) {
    let auxLabel = UILabel(frame: label.frame)
    auxLabel.text = text
    auxLabel.font = label.font
    auxLabel.textAlignment = label.textAlignment
    auxLabel.textColor = label.textColor
    auxLabel.backgroundColor = .clear
    
    auxLabel.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
    auxLabel.alpha = 0
    
    view.addSubview(auxLabel)
    
    /// Reset the auxiliary label’s transform above, effectively moving it to its original location and
    /// fade the text in by animating its alpha value.
    UIView.animate(
      withDuration: 0.25,
      delay: 0.1,
      options: .curveEaseIn,
      animations: {
        auxLabel.transform = .identity
        auxLabel.alpha = 1.0
      },
      completion: { _ in
        // clean up
        auxLabel.removeFromSuperview()
        label.text = text
        label.alpha = 1.0
        label.transform = .identity
      }
    )
  }
  
  /// Using keyframe animation to animate the plane image
  func planeDepart() {
    /// store the original position of the airplane in `originalCenter` so we know where our animation should finish
    let originalCenter = planeImage.center
    
    UIView.animateKeyframes(
      withDuration: 1.5,
      delay: 0.0,
      animations: {
        // add keyframes for 4 different phrases
        
        /// Phase 1: Slowly fly up
        UIView.addKeyframe(
          withRelativeStartTime: 0.0,
          relativeDuration: 0.25, // 25% of the duration time
          animations: {
            self.planeImage.center.x += 80.0 // move 80 point to the right
            self.planeImage.center.y -= 10.0 // move 10 points up
          }
        )
        
        /// Phase 2: go skyward steeply
        UIView.addKeyframe(
          withRelativeStartTime: 0.1,
          relativeDuration: 0.4, // 40% of the duration time
          animations: {
            self.planeImage.transform = CGAffineTransform(rotationAngle: -.pi / 8)
          }
        )
        
        /// Phase 3: airplane moving along but start to fade it out
        UIView.addKeyframe(
          withRelativeStartTime: 0.25,
          relativeDuration: 0.25,  // 25% of the duration time
          animations: {
            self.planeImage.center.x += 100.0
            self.planeImage.center.y -= 50.0
            self.planeImage.alpha = 0.0
          }
        )
        
        /// Phase 4:
        /// reset the plane transform and move it to the left edge of the screen
        UIView.addKeyframe(
          withRelativeStartTime: 0.51,
          relativeDuration: 0.01, // 1% of the duration time
          animations: {
            self.planeImage.transform = .identity
            self.planeImage.center = CGPoint(x: 0.0, y: originalCenter.y)
          }
        )
        /// Bring the plane back to the original location
        UIView.addKeyframe(
          withRelativeStartTime: 0.55,
          relativeDuration: 0.45,
          animations: {
            self.planeImage.alpha = 1.0
            self.planeImage.center = originalCenter
          }
        )
      },
      completion: nil
    )
  }
  
  /// Using keyframe animation to animate the summaryString label
  func summaryStringSwitch(to summaryText: String) {
    UIView.animateKeyframes(
      withDuration: 1.0,
      delay: 0.0,
      animations: {
        UIView.addKeyframe(
          withRelativeStartTime: 0.0,
          relativeDuration: 0.45,
          animations: {
            self.summaryString.center.y -= 100.0
          }
        )
        UIView.addKeyframe(
          withRelativeStartTime: 0.5,
          relativeDuration: 0.45,
          animations: {
            self.summaryString.center.y += 100.0
          }
        )
      },
      completion: nil
    )
    
    delay(seconds: 0.5) {
      self.summaryString.text = summaryText
    }
  }
}

// MARK: - Setup views and constriants
extension ViewController {
  
  func setupViews() {
    navStackView.addArrangedSubview(summaryIcon)
    navStackView.addArrangedSubview(summaryString)
    navigationItem.titleView = navStackView
    
    view.addSubview(bgImageView)
    
    view.addSubview(flightLabel)
    view.addSubview(gateLabel)
    view.addSubview(flightNr)
    view.addSubview(gateNr)
    
    view.addSubview(planeImage)
    view.addSubview(departingFrom)
    view.addSubview(arrivingTo)
    
    view.addSubview(statusBanner)
    statusBanner.addSubview(flightStatus)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      // bgImageView
      bgImageView.heightAnchor.constraint(equalTo: view.heightAnchor),
      bgImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
      
      // flightLabel
      flightLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      flightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
      
      // gateLabel
      gateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      gateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -85),
      
      // flightNr
      flightNr.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
      flightNr.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      flightNr.widthAnchor.constraint(equalToConstant: 100),
      
      // gateNr
      gateNr.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
      gateNr.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      gateNr.widthAnchor.constraint(equalToConstant: 100),
      
      // Plane
      planeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      planeImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
      
      // departingFrom label
      departingFrom.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      departingFrom.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
      
      // arrivingTo label
      arrivingTo.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      arrivingTo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
      
      // statusBanner
      statusBanner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
      statusBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      statusBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      
      flightStatus.centerXAnchor.constraint(equalTo: statusBanner.centerXAnchor),
      flightStatus.centerYAnchor.constraint(equalTo: statusBanner.centerYAnchor),
      flightStatus.widthAnchor.constraint(equalToConstant: 200)
      
    ])
  }
}
