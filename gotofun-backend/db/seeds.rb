# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_title|
#     MovieGenre.find_or_create_by!(title: genre_title)
#   end
Activity.find_or_create_by(
    title: "Cola Beach",
    description: "Pristine beach with safe conditions and great weather for a relaxing day.",
    lat: -34.0045,
    long: 22.7800
)

Activity.find_or_create_by(
    title: "Sedgefield Classic Cars",
    description: "A family-friendly outing showcasing beautifully restored classic cars.",
    lat: -34.0351,
    long: 22.8015
)

Activity.find_or_create_by(
    title: "Paraglide Africa",
    description: "Adrenaline-pumping air tours with professional guides for an unforgettable experience.",
    lat: -34.0395,
    long: 22.8101
)

Activity.find_or_create_by(
    title: "Adrenaline Sailing",
    description: "Enjoy a three-day sailing course on the beautiful Swartvlei near Sedgefield.",
    lat: -34.0216,
    long: 22.8083
)

Activity.find_or_create_by(
    title: "Circles in the Forest Hike",
    description: "Picturesque forest walk with a choice of short or long trails, rich in flora and fauna.",
    lat: -33.9358,
    long: 23.1476
)

Activity.find_or_create_by(
    title: "Half-Collared Kingfisher Trail",
    description: "Indigenous forest trail alongside Touw River offering serene river views.",
    lat: -33.9880,
    long: 22.5750
)

Activity.find_or_create_by(
    title: "Cloud Nine Circular Route",
    description: "A 15km circular bike ride with panoramic views of the town, lagoon, and ocean.",
    lat: -34.0371,
    long: 22.8109
)

Activity.find_or_create_by(
    title: "Gerickes Point",
    description: "Enjoy a beach hike, explore rock pools and snorkeling spots in this scenic area.",
    lat: -34.0075,
    long: 22.7512
)

Activity.find_or_create_by(
    title: "Redberry Farm",
    description: "Family-friendly destination with strawberry picking, hedge maze, mini train, pony rides, and more.",
    lat: -33.9669,
    long: 22.4572
)

Activity.find_or_create_by(
    title: "Outeniqua Transport Museum",
    description: "A museum showcasing the history of South African Railways with a collection of steam locomotives and coaches.",
    lat: -33.9630,
    long: 22.4597
)

Activity.find_or_create_by(
    title: "George Peak Hike",
    description: "A strenuous trail to the summit of George Peak offering spectacular views of the region.",
    lat: -33.9630,
    long: 22.4597
)

Activity.find_or_create_by(
    title: "The Farm Coffee Shop",
    description: "Charming coffee shop offering a variety of healthy options, pizza, and picturesque views.",
    lat: -34.0361,
    long: 23.0466
)