//
//  WeatherTVC.swift
//  WeatherApp
//

class WeatherTVC: UITableViewCell {

    //MARK: - UILabel Outlets
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCurrentTemp: UILabel!
    @IBOutlet weak var lblHighLowTemp: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblSunriseTime: UILabel!
    @IBOutlet weak var lblSunsetTime: UILabel!

    //MARK: - UIImageView Outlet
    @IBOutlet weak var imgvIcon: UIImageView!

    //MARK: - Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
