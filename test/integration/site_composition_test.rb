# frozen_string_literal: true

require 'test_helper'

class SiteCompositionTest < ActionDispatch::IntegrationTest
  test 'community introduction carousel' do
    get root_path
    assert_select '#introduction-carousel', count: 1
    assert_select '.carousel-indicators', count: 1
    assert_select '.carousel-indicators > li', count: 4
    assert_select '.carousel-inner', count: 1
    assert_select '.item', count: 4
    assert_select '.item > img', count: 4
    assert_select '.carousel-caption', count: 4
    assert_select '.carousel-control', count: 2
  end

  test 'community introduction' do
    get root_path
    assert_select '#introduction', count: 1
    assert_select '#introduction h1', count: 1
    assert_select '#introduction h1 > small', count: 1
  end

  test 'community membership' do
    get root_path
    assert_select '#membership', count: 1
    assert_select 'table#admission_fee', count: 1
    assert_select 'tr', count: 4
    assert_select 'th', count: 4
    assert_select 'td', count: 12
  end

  test 'community board of directors and contact' do
    get root_path
    assert_select '#about_board_of_directors', count: 1
    assert_select '#contact', count: 1
  end

  test 'community directions' do
    get root_path
    assert_select '#directions', count: 1
    assert_select '#directions > script', count: 1
    assert_select '.directions', count: 1
    assert_select '.about_directions', count: 1
    assert_select '#map', count: 1
    assert_match '/assets/google_maps', response.body
    assert_match 'https://maps.googleapis.com/maps/api/js?', response.body
    assert_match 'callback=initGoogleMap', response.body
  end
end
